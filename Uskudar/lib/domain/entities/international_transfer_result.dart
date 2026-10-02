class InternationalTransferResult {
  const InternationalTransferResult({
    required this.toFullName,
    required this.toInfo,
    required this.amount,
    required this.commissionAmount,
    required this.commissionFrom,
    required this.transactionNumber,
    required this.receivedPaymentAmount,
    required this.receivedPaymentAmountCurrency,
  });

  final String toFullName;
  final String toInfo;
  final double amount;
  final double commissionAmount;
  final String commissionFrom;
  final String transactionNumber;
  final double receivedPaymentAmount;
  final String receivedPaymentAmountCurrency;
}
