// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commission_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommissionResponse _$CommissionResponseFromJson(Map<String, dynamic> json) =>
    CommissionResponse(
      id: json['id'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      updatedDate: json['updatedDate'] == null
          ? null
          : DateTime.parse(json['updatedDate'] as String),
      defaultAmount: (json['defaultAmount'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      isCustom: json['isCustom'] as bool?,
      defaultCommissionMoneyTypeId:
          (json['defaultCommissionMoneyTypeId'] as num?)?.toInt(),
      defaultCommissionMoneyTypeName:
          json['defaultCommissionMoneyTypeName'] as String?,
      customerTypeId: (json['customerTypeId'] as num?)?.toInt(),
      customerTypeName: json['customerTypeName'] as String?,
      transferOperationTypeId: (json['transferOperationTypeId'] as num?)
          ?.toInt(),
      transferOperationTypeName: json['transferOperationTypeName'] as String?,
      prevProcessCount: (json['prevProcessCount'] as num?)?.toInt(),
      processPrevMoneyTypeId: (json['processPrevMoneyTypeId'] as num?)?.toInt(),
      processPrevMoneyTypeName: json['processPrevMoneyTypeName'] as String?,
      processPrevMoney: (json['processPrevMoney'] as num?)?.toDouble(),
      commissionFromTypeId: (json['commissionFromTypeId'] as num?)?.toInt(),
      commissionFromTypeName: json['commissionFromTypeName'] as String?,
      processPrevTimeTypeId: (json['processPrevTimeTypeId'] as num?)?.toInt(),
      processPrevTimeTypeName: json['processPrevTimeTypeName'] as String?,
    );
