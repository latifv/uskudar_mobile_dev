import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/params/change_password_params.dart';
import 'package:payinall/domain/params/forgot_change_password_params.dart';
import 'package:payinall/domain/params/forgot_password_params.dart';
import 'package:payinall/domain/params/merchant_user_forgot_change_password_params.dart';
import 'package:payinall/domain/params/merchant_user_forgot_password_params.dart';
import 'package:payinall/domain/params/question_name_params.dart';

abstract interface class PasswordsRepository {
  Future<Either<Failure, void>> changePassword(ChangePasswordParams params);
  Future<Either<Failure, String>> forgotPassword(ForgotPasswordParams params);
  Future<Either<Failure, String>> getQuestionName(QuestionNameParams params);
  Future<Either<Failure, void>> forgotChangePassword(
    ForgotChangePasswordParams params,
  );
  Future<Either<Failure, String>> merchantUserForgotPassword(
    MerchantUserForgotPasswordParams params,
  );
  Future<Either<Failure, void>> merchantUserForgotChangePassword(
    MerchantUserForgotChangePasswordParams params,
  );
}
