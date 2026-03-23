class ForgotPasswordParams {
  const ForgotPasswordParams({
    required this.gsmNumber,
    required this.identityNumber,
    required this.answer,
  });

  final String gsmNumber;
  final String identityNumber;
  final String answer;
}
