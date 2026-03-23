class ChangePasswordParams {
  const ChangePasswordParams({
    required this.identityNumber,
    required this.oldPassword,
    required this.newPassword,
    required this.retryNewPassword,
  });

  final String identityNumber;
  final String oldPassword;
  final String newPassword;
  final String retryNewPassword;
}
