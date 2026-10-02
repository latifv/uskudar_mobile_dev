import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/current_user_info.dart';
import 'package:uskudar_mobile/domain/params/email_verification_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/register_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_confirm_params.dart';
import 'package:uskudar_mobile/domain/params/update_email_send_code_params.dart';
import 'package:uskudar_mobile/domain/params/update_secret_question_params.dart';

abstract interface class UsersRepository {
  Future<Either<Failure, void>> register(RegisterParams params);
  Future<Either<Failure, CurrentUserInfo>> getCurrentUserInfo();
  Future<Either<Failure, void>> changeNotification(int notificationTypeId);
  Future<Either<Failure, String>> remove();
  Future<Either<Failure, String>> updateSecretQuestion(
    UpdateSecretQuestionParams params,
  );
  Future<Either<Failure, String>> emailVerificationSendCode();
  Future<Either<Failure, String>> emailVerificationConfirm(
    EmailVerificationConfirmParams params,
  );
  Future<Either<Failure, String>> updateEmailSendCode(
    UpdateEmailSendCodeParams params,
  );
  Future<Either<Failure, String>> updateEmailConfirm(
    UpdateEmailConfirmParams params,
  );
}
