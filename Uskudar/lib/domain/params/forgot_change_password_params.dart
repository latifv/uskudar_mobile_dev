class ForgotChangePasswordParams {
  const ForgotChangePasswordParams({
    required this.password,
    required this.rePassword,
    required this.code,
    required this.address,
  });

  final String password;
  final String rePassword;
  final String code;
  final String address;
}
