class WithdrawTransfer {
  const WithdrawTransfer({
    required this.fullName,
    required this.ibanNumber,
    required this.amount,
    required this.commissionAmount,
    required this.commissionFrom,
    required this.transactionNumber,
  });

  final String fullName;
  final String ibanNumber;
  final double amount;
  final double commissionAmount;
  final String commissionFrom;
  final String transactionNumber;
}
