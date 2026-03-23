class TransactionsParams {
  const TransactionsParams({
    required this.startDate,
    required this.endDate,
    required this.transferOperationType,
  });

  final DateTime startDate;
  final DateTime endDate;
  final int transferOperationType;
}
