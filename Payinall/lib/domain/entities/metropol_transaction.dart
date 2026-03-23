class MetropolTransaction {
  const MetropolTransaction({
    required this.cardNo,
    required this.personnelNo,
    required this.transactionId,
    required this.transactionInfo,
    required this.transactionDate,
    required this.amount,
    required this.walletId,
    required this.walletName,
    required this.merchantName,
    required this.dayCount,
    required this.paymentTypeId,
  });

  final String cardNo;
  final String personnelNo;
  final String transactionId;
  final String transactionInfo;
  final String transactionDate;
  final String amount;
  final String walletId;
  final String walletName;
  final String merchantName;
  final int dayCount;
  final int paymentTypeId;
}
