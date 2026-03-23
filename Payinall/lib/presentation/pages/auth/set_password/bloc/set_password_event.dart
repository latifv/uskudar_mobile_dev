part of 'set_password_bloc.dart';

sealed class SetPasswordEvent {
  const SetPasswordEvent();
}

final class SetPasswordSubmit extends SetPasswordEvent {
  const SetPasswordSubmit(
    this.code,
    this.firstName,
    this.lastName,
    this.tcNo,
    this.email,
    this.phoneNumber,
    this.birthDate,
    this.password,
    this.confirmPassword,
    this.userQuestionId,
    this.secretQuestion,
    this.seriNo,
  );

  final String code;
  final String firstName;
  final String lastName;
  final String tcNo;
  final String email;
  final String phoneNumber;
  final String birthDate;
  final String password;
  final String confirmPassword;
  final int userQuestionId;
  final String secretQuestion;
  final String seriNo;
}
