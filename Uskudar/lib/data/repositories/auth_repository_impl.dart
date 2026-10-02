import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/local/auth_local_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/auth_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/auth_merchant_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/auth_mobile_request.dart';
import 'package:uskudar_mobile/data/models/auth_mobile_model.dart';
import 'package:uskudar_mobile/data/models/logged_in_model.dart';
import 'package:uskudar_mobile/domain/entities/auth_mobile.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';
import 'package:uskudar_mobile/domain/params/auth_merchant_params.dart';
import 'package:uskudar_mobile/domain/params/auth_mobile_params.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.tokenManager,
  }) : _dataSourceHandler = DataSourceHandler();

  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;
  final TokenManager tokenManager;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, AuthMobile>> authMobile(
    AuthMobileParams params,
  ) async {
    return _dataSourceHandler.handle<AuthMobile, AuthMobileModel>(
      remoteFunction: () async {
        final request = AuthMobileRequest.fromParams(params);
        final result = await remoteDataSource.authMobile(request);
        return result;
      },
      cacheData: (data) async {
        if (data.token != null) {
          final authToken = AuthToken(
            token: data.token!.token,
            expiration: data.token!.expiration,
            endDateMinute: data.token!.endDateMinute,
          );
          tokenManager.setToken(authToken);
        }
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, AuthMobile>> authMerchant(
    AuthMerchantParams params,
  ) async {
    return _dataSourceHandler.handle<AuthMobile, AuthMobileModel>(
      remoteFunction: () async {
        final request = AuthMerchantRequest.fromParams(params);
        final result = await remoteDataSource.authMerchant(request);
        return result;
      },
      cacheData: (data) async {
        if (data.token != null) {
          final authToken = AuthToken(
            token: data.token!.token,
            expiration: data.token!.expiration,
            endDateMinute: data.token!.endDateMinute,
          );
          tokenManager.setToken(authToken);
        }
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, LoggedIn?>> getLoggedIn() async {
    return _dataSourceHandler.handle<LoggedIn?, void>(
      localFunction: () async {
        final result = await localDataSource.getLoggedIn();
        return result;
      },
    );
  }

  @override
  Future<Either<Failure, void>> saveLoggedIn(LoggedIn loggedIn) async {
    return _dataSourceHandler.handle<void, void>(
      localFunction: () async {
        await localDataSource.saveLoggedIn(LoggedInModel.fromEntity(loggedIn));
      },
    );
  }
}
