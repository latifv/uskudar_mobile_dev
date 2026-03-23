class AuthMobileParams {
  const AuthMobileParams({
    required this.loginInfo,
    required this.password,
    this.deviceId,
  });

  final String loginInfo;
  final String password;
  final String? deviceId;
}
