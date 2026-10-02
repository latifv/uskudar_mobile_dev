part of 'reset_password_bloc.dart';

sealed class ResetPasswordEvent {
  const ResetPasswordEvent();
}

final class ResetPasswordSubmit extends ResetPasswordEvent {
  const ResetPasswordSubmit(
    this.newPassword,
    this.confirmPassword,
    this.code,
    this.address, {
    this.isMerchant = false,
    this.processCode,
    this.customerNumber,
  });

  final String newPassword;
  final String confirmPassword;
  final String code;
  final String address;
  final bool isMerchant;
  final String? processCode;
  final String? customerNumber;
}
