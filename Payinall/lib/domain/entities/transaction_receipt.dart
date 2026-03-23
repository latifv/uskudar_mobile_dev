class TransactionReceipt {
  const TransactionReceipt({
    required this.transferOperationTypeName,
    required this.orderNumber,
    required this.receiptNo,
    required this.fromCustomerFullName,
    required this.transferStatusTypeName,
    required this.commissionFromTypeName,
    required this.createdDate,
    required this.amount,
    required this.commissionAmount,
    required this.description,
    required this.institutionAddress,
    required this.institutionTaxOffice,
    required this.institutionTaxNo,
    required this.institutionName,
    required this.basisAmount,
    required this.bsmvAmount,
    required this.bsmvRate,
    this.toCustomerFullName,
    this.toCustomerNumber,
    this.fromCustomerNumber,
  });

  final String transferOperationTypeName;
  final String orderNumber;
  final String receiptNo;
  final String fromCustomerFullName;
  final String? fromCustomerNumber;
  final String transferStatusTypeName;
  final String commissionFromTypeName;
  final String? toCustomerFullName;
  final String? toCustomerNumber;
  final DateTime createdDate;
  final double amount;
  final double commissionAmount;
  final String description;
  final String institutionAddress;
  final String institutionTaxOffice;
  final String institutionTaxNo;
  final String institutionName;
  final double basisAmount;
  final double bsmvAmount;
  final double bsmvRate;
}
