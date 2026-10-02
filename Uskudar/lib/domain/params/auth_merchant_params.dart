class AuthMerchantParams {
  const AuthMerchantParams({
    required this.customerNumber,
    required this.gsmNumber,
    required this.password,
    this.deviceId,
  });

  final String customerNumber;
  final String gsmNumber;
  final String password;
  final String? deviceId;
}
