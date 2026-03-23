class BillInquiry {
  const BillInquiry({
    required this.subscriberName,
    required this.transactionQueryId,
    required this.invoiceAmount,
    required this.billNo,
    required this.billDueDate,
  });

  final String subscriberName;
  final String transactionQueryId;
  final double invoiceAmount;
  final String billNo;
  final DateTime billDueDate;
}
