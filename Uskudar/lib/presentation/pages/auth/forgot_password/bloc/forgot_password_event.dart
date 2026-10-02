part of 'forgot_password_bloc.dart';

sealed class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

final class ForgotPasswordSubmit extends ForgotPasswordEvent {
  const ForgotPasswordSubmit(this.phoneNumber, this.answer, this.tcNumber);

  final String phoneNumber;
  final String answer;
  final String tcNumber;
}
