class GetOfficesParams {
  const GetOfficesParams({
    required this.countryCode,
    required this.officeType,
    required this.corporationCode,
  });

  final String countryCode;
  final String officeType;
  final String corporationCode;
}
