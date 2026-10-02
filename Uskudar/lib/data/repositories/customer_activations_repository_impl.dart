import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_activations_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_activation_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_merchant_activation_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/send_new_code_request.dart';
import 'package:uskudar_mobile/data/models/auth_token_model.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';
import 'package:uskudar_mobile/domain/params/check_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/check_merchant_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/send_new_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_activations_repository.dart';

final class CustomerActivationsRepositoryImpl
    implements CustomerActivationsRepository {
  CustomerActivationsRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenManager,
  }) : _dataSourceHandler = DataSourceHandler();

  final CustomerActivationsRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, DataWithMessage<String>>> sendNewCode(
    SendNewCodeParams params,
  ) async {
    return _dataSourceHandler.handle<DataWithMessage<String>, String>(
      remoteFunction: () async {
        final request = SendNewCodeRequest.fromParams(params);
        final result = await remoteDataSource.sendNewCode(request);
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, AuthToken>> checkActivationCode(
    CheckActivationCodeParams params,
  ) async {
    return _dataSourceHandler.handle<AuthToken, AuthTokenModel>(
      remoteFunction: () async {
        final request = CheckActivationCodeRequest.fromParams(params);
        final result = await remoteDataSource.checkActivationCode(request);
        return result;
      },
      cacheData: (data) async {
        final authToken = AuthToken(
          token: data.token,
          expiration: data.expiration,
          endDateMinute: data.endDateMinute,
        );
        tokenManager.setToken(authToken);
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, AuthToken>> checkMerchantActivationCode(
    CheckMerchantActivationCodeParams params,
  ) async {
    return _dataSourceHandler.handle<AuthToken, AuthTokenModel>(
      remoteFunction: () async {
        final request = CheckMerchantActivationCodeRequest.fromParams(params);
        final result = await remoteDataSource.checkMerchantActivationCode(
          request,
        );
        return result;
      },
      cacheData: (data) async {
        final authToken = AuthToken(
          token: data.token,
          expiration: data.expiration,
          endDateMinute: data.endDateMinute,
        );
        tokenManager.setToken(authToken);
      },
      onlyData: true,
    );
  }
}
