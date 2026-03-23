class WithdrawTransferParams {
  const WithdrawTransferParams({
    required this.ibanNumber,
    required this.amount,
  });

  final String ibanNumber;
  final double amount;
}
