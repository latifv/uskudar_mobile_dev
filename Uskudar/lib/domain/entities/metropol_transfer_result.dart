class MetropolTransferResult {
  const MetropolTransferResult({
    required this.merchantName,
    required this.cityName,
    required this.districtName,
    required this.requestAmount,
    required this.transactionId,
    required this.productName,
    required this.kdv,
    required this.saleRefCode,
    required this.sessionExpireDate,
  });

  final String merchantName;
  final String cityName;
  final String districtName;
  final String requestAmount;
  final int transactionId;
  final String productName;
  final String kdv;
  final String saleRefCode;
  final String sessionExpireDate;
}
