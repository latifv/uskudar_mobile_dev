import 'package:json_annotation/json_annotation.dart';

part 'commission_response.g.dart';

@JsonSerializable(createToJson: false)
final class CommissionResponse {
  const CommissionResponse({
    this.id,
    this.createdDate,
    this.updatedDate,
    this.defaultAmount,
    this.isActive,
    this.isCustom,
    this.defaultCommissionMoneyTypeId,
    this.defaultCommissionMoneyTypeName,
    this.customerTypeId,
    this.customerTypeName,
    this.transferOperationTypeId,
    this.transferOperationTypeName,
    this.prevProcessCount,
    this.processPrevMoneyTypeId,
    this.processPrevMoneyTypeName,
    this.processPrevMoney,
    this.commissionFromTypeId,
    this.commissionFromTypeName,
    this.processPrevTimeTypeId,
    this.processPrevTimeTypeName,
  });

  factory CommissionResponse.fromJson(Map<String, dynamic> json) =>
      _$CommissionResponseFromJson(json);

  final String? id;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final double? defaultAmount;
  final bool? isActive;
  final bool? isCustom;
  final int? defaultCommissionMoneyTypeId;
  final String? defaultCommissionMoneyTypeName;
  final int? customerTypeId;
  final String? customerTypeName;
  final int? transferOperationTypeId;
  final String? transferOperationTypeName;
  final int? prevProcessCount;
  final int? processPrevMoneyTypeId;
  final String? processPrevMoneyTypeName;
  final double? processPrevMoney;
  final int? commissionFromTypeId;
  final String? commissionFromTypeName;
  final int? processPrevTimeTypeId;
  final String? processPrevTimeTypeName;
}
