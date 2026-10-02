part of 'login_bloc.dart';

sealed class LoginEvent {
  const LoginEvent();
}

final class LoginSubmit extends LoginEvent {
  const LoginSubmit(
    this.identifier,
    this.password, {
    this.isMerchant = false,
    this.customerNumber,
    this.gsmNumber,
  });

  final String identifier;
  final String password;
  final bool isMerchant;
  final String? customerNumber;
  final String? gsmNumber;
}

final class LoginRememberMeChange extends LoginEvent {
  const LoginRememberMeChange({required this.isChecked});
  final bool isChecked;
}

final class LoginTypeChange extends LoginEvent {
  const LoginTypeChange(this.loginType);

  final LoginType loginType;
}
