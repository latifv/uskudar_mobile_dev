class MerchantUserForgotChangePasswordParams {
  const MerchantUserForgotChangePasswordParams({
    required this.gsmNumber,
    required this.customerNumber,
    required this.code,
    required this.password,
    required this.processCode,
  });

  final String gsmNumber;
  final String customerNumber;
  final String code;
  final String password;
  final String processCode;
}
