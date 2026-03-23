class ChangePhoneCodeParams {
  const ChangePhoneCodeParams({
    required this.newGsmNumber,
    required this.identityNumber,
    required this.answer,
  });

  final String newGsmNumber;
  final String identityNumber;
  final String answer;
}
