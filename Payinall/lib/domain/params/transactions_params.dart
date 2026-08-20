class TransactionsParams {
  const TransactionsParams({
    required this.startDate,
    required this.endDate,
    required this.transferOperationType,
    this.pageNumber = 1,
    this.pageSize = 20,
  });

  final DateTime startDate;
  final DateTime endDate;
  final int transferOperationType;
  final int pageNumber;
  final int pageSize;
}
