class BillPaymentParams {
  const BillPaymentParams({
    required this.subscriberName,
    required this.transactionQueryId,
    required this.invoiceAmount,
  });

  final String subscriberName;
  final String transactionQueryId;
  final double invoiceAmount;
}
