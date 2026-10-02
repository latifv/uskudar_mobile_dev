class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.commissionAmount,
    required this.commissionType,
    required this.description,
    required this.transferType,
    required this.statusName,
    required this.fromFullName,
    required this.date,
    this.fromAddress,
    this.toFullName,
    this.toCustomerNumber,
    this.transactionTypes,
    this.commissionFromType,
    this.oldBalance,
    this.newBalance,
  });
  final String id;
  final double amount;
  final double commissionAmount;
  final String commissionType;
  final String description;
  final String transferType;
  final String statusName;
  final String fromFullName;
  final String? toFullName;
  final DateTime date;
  final String? toCustomerNumber;
  final String? fromAddress;
  final int? transactionTypes;
  final int? commissionFromType;
  final double? oldBalance;
  final double? newBalance;
  bool get isIncoming {
    return transactionTypes == 1;
  }
}
