part of 'password_confirmation_bloc.dart';

sealed class PasswordConfirmationEvent {
  const PasswordConfirmationEvent();
}

final class PasswordConfirmationSubmit extends PasswordConfirmationEvent {
  const PasswordConfirmationSubmit(this.password, this.identifier);

  final String password;
  final String identifier;
}

final class PasswordConfirmationLogout extends PasswordConfirmationEvent {
  const PasswordConfirmationLogout();
}
