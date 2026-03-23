class WalletTransfer {
  const WalletTransfer({
    required this.buyerFullName,
    required this.buyerInfo,
    required this.amount,
    required this.commissionAmount,
    required this.commissionFrom,
    required this.transactionNumber,
  });

  final String buyerFullName;
  final String buyerInfo;
  final double amount;
  final double commissionAmount;
  final String commissionFrom;
  final String transactionNumber;
}
