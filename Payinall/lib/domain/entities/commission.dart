class Commission {
  const Commission({
    required this.id,
    required this.createdDate,
    required this.updatedDate,
    required this.defaultAmount,
    required this.isActive,
    required this.isCustom,
    required this.defaultCommissionMoneyTypeId,
    required this.defaultCommissionMoneyTypeName,
    required this.customerTypeId,
    required this.customerTypeName,
    required this.transferOperationTypeId,
    required this.transferOperationTypeName,
    required this.prevProcessCount,
    required this.processPrevMoneyTypeId,
    required this.processPrevMoneyTypeName,
    required this.processPrevMoney,
    required this.commissionFromTypeId,
    required this.commissionFromTypeName,
    required this.processPrevTimeTypeId,
    required this.processPrevTimeTypeName,
  });

  final String id;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final double defaultAmount;
  final bool isActive;
  final bool isCustom;
  final int defaultCommissionMoneyTypeId;
  final String defaultCommissionMoneyTypeName;
  final int customerTypeId;
  final String customerTypeName;
  final int transferOperationTypeId;
  final String transferOperationTypeName;
  final int prevProcessCount;
  final int processPrevMoneyTypeId;
  final String processPrevMoneyTypeName;
  final double processPrevMoney;
  final int commissionFromTypeId;
  final String commissionFromTypeName;
  final int processPrevTimeTypeId;
  final String processPrevTimeTypeName;
}
