class EmailVerificationConfirmParams {
  const EmailVerificationConfirmParams({
    required this.code,
    required this.processCode,
  });

  final String code;
  final String processCode;
}
