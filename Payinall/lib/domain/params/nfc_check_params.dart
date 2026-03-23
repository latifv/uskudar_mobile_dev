class NfcCheckParams {
  const NfcCheckParams({
    required this.mrz,
    required this.processId,
    this.dg1Base64,
    this.dg2Base64,
    this.dg3Base64,
    this.dg4Base64,
    this.dg5Base64,
    this.dg6Base64,
    this.dg7Base64,
    this.dg8Base64,
    this.dg9Base64,
    this.dg10Base64,
    this.dg11Base64,
    this.dg12Base64,
    this.dg13Base64,
    this.dg14Base64,
    this.dg15Base64,
    this.dg16Base64,
    this.efComBase64,
    this.challengeBase64,
    this.activeAuthenticationResponseBase64,
    this.efSodBase64,
  });

  final String? dg1Base64;
  final String? dg2Base64;
  final String? dg3Base64;
  final String? dg4Base64;
  final String? dg5Base64;
  final String? dg6Base64;
  final String? dg7Base64;
  final String? dg8Base64;
  final String? dg9Base64;
  final String? dg10Base64;
  final String? dg11Base64;
  final String? dg12Base64;
  final String? dg13Base64;
  final String? dg14Base64;
  final String? dg15Base64;
  final String? dg16Base64;
  final String? efComBase64;
  final String? challengeBase64;
  final String? activeAuthenticationResponseBase64;
  final String? efSodBase64;
  final String processId;
  final String mrz;
}
