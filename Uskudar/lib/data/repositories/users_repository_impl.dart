import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/users_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/email_verification_confirm_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/register_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/update_email_confirm_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/update_email_send_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/update_secret_question_request.dart';
import 'package:uskudar_mobile/data/models/current_user_info_model.dart';
import 'package:uskudar_mobile/domain/entities/current_user_info.dart';
import 'package:uskudar_mobile/domain/params/email_verification_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/register_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_send_code_params.dart';
import 'package:uskudar_mobile/domain/params/update_secret_question_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final UsersRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, void>> register(RegisterParams params) async {
    return _dataSourceHandler.handle<void, String>(
      remoteFunction: () async {
        final request = RegisterRequest.fromParams(params);
        final result = await remoteDataSource.register(request);
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, String>> remove() async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.remove();
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, CurrentUserInfo>> getCurrentUserInfo() async {
    return _dataSourceHandler.handle<CurrentUserInfo, CurrentUserInfoModel>(
      remoteFunction: () async {
        final result = await remoteDataSource.getCurrentUserInfo();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, void>> changeNotification(
    int notificationTypeId,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.changeNotification(
          notificationTypeId,
        );
        return result;
      },
      onlyResponseType: true,
    );
  }

  @override
  Future<Either<Failure, String>> updateSecretQuestion(
    UpdateSecretQuestionParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = UpdateSecretQuestionRequest.fromParams(params);
        final result = await remoteDataSource.updateSecretQuestion(request);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> emailVerificationSendCode() async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final result = await remoteDataSource.emailVerificationSendCode();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> emailVerificationConfirm(
    EmailVerificationConfirmParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request =
            EmailVerificationConfirmRequest.fromParams(params);
        final result = await remoteDataSource.emailVerificationConfirm(request);
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, String>> updateEmailSendCode(
    UpdateEmailSendCodeParams params,
  ) async {
    return _dataSourceHandler.handle<String, String>(
      remoteFunction: () async {
        final request = UpdateEmailSendCodeRequest.fromParams(params);
        final result = await remoteDataSource.updateEmailSendCode(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> updateEmailConfirm(
    UpdateEmailConfirmParams params,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final request = UpdateEmailConfirmRequest.fromParams(params);
        final result = await remoteDataSource.updateEmailConfirm(request);
        return result;
      },
      onlyMessage: true,
    );
  }
}
