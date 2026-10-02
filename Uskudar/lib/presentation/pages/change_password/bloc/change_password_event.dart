part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

final class ChangePasswordSubmit extends ChangePasswordEvent {
  const ChangePasswordSubmit({
    required this.identityNumber,
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String identityNumber;
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
}
