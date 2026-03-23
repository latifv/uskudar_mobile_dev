class CustomerProcess {
  const CustomerProcess({
    required this.timeInfo,
    required this.onlyTransferLimit,
    required this.processName,
    required this.remainingNumberOfTransactions,
    required this.remainingAmountOfMoney,
  });
  final String timeInfo;
  final int onlyTransferLimit;
  final String processName;
  final int remainingNumberOfTransactions;
  final int remainingAmountOfMoney;
}
