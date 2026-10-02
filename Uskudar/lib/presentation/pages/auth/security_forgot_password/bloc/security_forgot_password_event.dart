part of 'security_forgot_password_bloc.dart';

sealed class SecurityForgotPasswordEvent {
  const SecurityForgotPasswordEvent();
}

final class SecurityForgotPasswordLoginTypeChange
    extends SecurityForgotPasswordEvent {
  const SecurityForgotPasswordLoginTypeChange(this.loginType);

  final LoginType loginType;
}

final class SecurityForgotPasswordSubmit extends SecurityForgotPasswordEvent {
  const SecurityForgotPasswordSubmit({
    this.tcNumber,
    this.gsmNumber,
    this.customerNumber,
  });

  final String? tcNumber;
  final String? gsmNumber;
  final String? customerNumber;
}
