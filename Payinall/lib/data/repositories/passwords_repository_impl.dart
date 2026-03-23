import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/passwords_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/change_password_request.dart';
import 'package:payinall/data/dtos/requests/forgot_change_password_request.dart';
import 'package:payinall/data/dtos/requests/forgot_password_request.dart';
import 'package:payinall/data/dtos/requests/merchant_user_forgot_change_password_request.dart';
import 'package:payinall/data/dtos/requests/merchant_user_forgot_password_request.dart';
import 'package:payinall/data/dtos/requests/question_name_request.dart';
import 'package:payinall/domain/params/change_password_params.dart';
import 'package:payinall/domain/params/forgot_change_password_params.dart';
import 'package:payinall/domain/params/forgot_password_params.dart';
import 'package:payinall/domain/params/merchant_user_forgot_change_password_params.dart';
import 'package:payinall/domain/params/merchant_user_forgot_password_params.dart';
import 'package:payinall/domain/params/question_name_params.dart';
import 'package:payinall/domain/repositories/passwords_repository.dart';

final class PasswordsRepositoryImpl implements PasswordsRepository {
  PasswordsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final PasswordsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> changePassword(
    ChangePasswordParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = ChangePasswordRequest.fromParams(params);
        final result = await remoteDataSource.changePassword(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final request = ForgotPasswordRequest.fromParams(params);
        final result = await remoteDataSource.forgotPassword(request);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> getQuestionName(
    QuestionNameParams params,
  ) async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final request = QuestionNameRequest.fromParams(params);
        final result = await remoteDataSource.getQuestionName(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, void>> forgotChangePassword(
    ForgotChangePasswordParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = ForgotChangePasswordRequest.fromParams(params);
        final result = await remoteDataSource.forgotChangePassword(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, String>> merchantUserForgotPassword(
    MerchantUserForgotPasswordParams params,
  ) async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final request = MerchantUserForgotPasswordRequest.fromParams(params);
        final result = await remoteDataSource.merchantUserForgotPassword(
          request,
        );
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, void>> merchantUserForgotChangePassword(
    MerchantUserForgotChangePasswordParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = MerchantUserForgotChangePasswordRequest.fromParams(
          params,
        );
        final result = await remoteDataSource.merchantUserForgotChangePassword(
          request,
        );
        return result;
      },
      onlyResponseType: true,
    );
  }
}
