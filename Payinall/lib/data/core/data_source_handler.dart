import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/data/network/models/network_response.dart';
import 'package:payinall/data/network/network_info.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

final class DataSourceHandler {
  DataSourceHandler();
  final NetworkInfo networkInfo = getIt<NetworkInfo>();

  Future<Either<Failure, Response>> handle<Response, Data>({
    Future<NetworkResponse<Data>> Function()? remoteFunction,
    Future<Response> Function()? localFunction,
    Future<void> Function(Data data)? cacheData,
    bool onlyData = false,
    bool onlyMessage = false,
    bool onlyResponseType = false,
    bool forceRemote = false,
  }) async {
    if (remoteFunction == null) {
      if (localFunction == null) {
        LogHelper.log(
          LogLevel.error,
          'Yerel veri kaynağı fonksiyonu bulunamadı',
        );
        return Left(CacheFailure(message: LocaleKeys.unknown_error.translate));
      }

      try {
        final result = await localFunction();
        return Right(result);
      } on CacheException catch (e) {
        LogHelper.log(LogLevel.error, e.toString());
        return Left(CacheFailure(message: e.message));
      } on Exception catch (e) {
        LogHelper.logCriticalError(e);
        return Left(CacheFailure(message: e.toString()));
      }
    }

    if (!forceRemote && localFunction != null) {
      try {
        final result = await localFunction();
        return Right(result);
      } on CacheException {
        LogHelper.log(
          LogLevel.debug,
          'Yerel veri bulunamadı, uzak veri kaynak kullanılacak',
        );
      } on Exception catch (e) {
        LogHelper.logCriticalError(e);
      }
    }

    bool isConnected;
    try {
      isConnected = await networkInfo.isConnected;
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.warning,
        'Bağlantı durumu kontrol edilemedi, bağlı varsayılıyor: $e',
      );
      isConnected = true;
    }

    if (isConnected) {
      try {
        final response = await remoteFunction();

        if (onlyResponseType && response.isSuccess) {
          return Right(true as Response);
        }

        if (response.isSuccess &&
            response.data != null &&
            response.message != null) {
          final responseData = response.data as Data;
          final responseMessage = response.message!;

          if (cacheData != null) {
            await cacheData(responseData);
          }
          if (onlyData) {
            return Right(responseData as Response);
          }
          if (onlyMessage) {
            return Right(responseMessage as Response);
          }
          return Right(
            DataWithMessage<Data>(message: responseMessage, data: responseData)
                as Response,
          );
        } else if (!response.isSuccess &&
            response.message != null &&
            response.data != null) {
          final responseMessage = response.message!;
          final responseData = response.data! as Data;
          return Left(
            ServerFailure(message: responseMessage, data: responseData),
          );
        } else if (response.isSuccess &&
            response.message != null &&
            response.data == null) {
          final responseMessage = response.message!;
          return Right(responseMessage as Response);
        } else if (!response.isSuccess &&
            response.message != null &&
            response.data == null) {
          final responseMessage = response.message!;
          return Left(ServerFailure(message: responseMessage));
        } else if (response.isSuccess &&
            response.data != null &&
            response.message == null) {
          final responseData = response.data as Data;

          if (cacheData != null) {
            await cacheData(responseData);
          }
          return Right(responseData as Response);
        } else if (!response.isSuccess &&
            response.data != null &&
            response.message == null) {
          final responseData = response.data! as Data;
          return Left(ServerFailure(data: responseData));
        } else if (response.isSuccess &&
            response.message == null &&
            response.data == null) {
          return Right(true as Response);
        } else if (!response.isSuccess &&
            response.message == null &&
            response.data == null) {
          return const Left(ServerFailure());
        } else {
          final responseMessage =
              response.message ?? LocaleKeys.server_error.translate;
          return Left(ServerFailure(message: responseMessage));
        }
      } on AppException catch (e) {
        LogHelper.log(LogLevel.error, e.toString());
        return Left(ServerFailure(message: e.message));
      } on Exception catch (e) {
        LogHelper.logCriticalError(e);
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      if (localFunction != null) {
        try {
          final result = await localFunction();
          return Right(result);
        } on CacheException catch (e) {
          LogHelper.log(LogLevel.error, e.toString());
          return Left(CacheFailure(message: e.message));
        } on Exception catch (e) {
          LogHelper.logCriticalError(e);
          return Left(CacheFailure(message: e.toString()));
        }
      } else {
        return Left(
          NetworkFailure(message: LocaleKeys.no_connection.translate),
        );
      }
    }
  }
}
