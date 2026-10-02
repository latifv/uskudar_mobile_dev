import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/commission_response.dart';
import 'package:uskudar_mobile/domain/entities/commission.dart';

final class CommissionModel extends Commission {
  const CommissionModel({
    required super.id,
    required super.createdDate,
    required super.updatedDate,
    required super.defaultAmount,
    required super.isActive,
    required super.isCustom,
    required super.defaultCommissionMoneyTypeId,
    required super.defaultCommissionMoneyTypeName,
    required super.customerTypeId,
    required super.customerTypeName,
    required super.transferOperationTypeId,
    required super.transferOperationTypeName,
    required super.prevProcessCount,
    required super.processPrevMoneyTypeId,
    required super.processPrevMoneyTypeName,
    required super.processPrevMoney,
    required super.commissionFromTypeId,
    required super.commissionFromTypeName,
    required super.processPrevTimeTypeId,
    required super.processPrevTimeTypeName,
  });

  factory CommissionModel.fromResponse(CommissionResponse response) {
    if (response.id == null ||
        response.createdDate == null ||
        response.defaultAmount == null ||
        response.isActive == null ||
        response.isCustom == null ||
        response.defaultCommissionMoneyTypeId == null ||
        response.defaultCommissionMoneyTypeName == null ||
        response.customerTypeId == null ||
        response.customerTypeName == null ||
        response.transferOperationTypeId == null ||
        response.transferOperationTypeName == null ||
        response.prevProcessCount == null ||
        response.processPrevMoneyTypeId == null ||
        response.processPrevMoneyTypeName == null ||
        response.processPrevMoney == null ||
        response.commissionFromTypeId == null ||
        response.commissionFromTypeName == null ||
        response.processPrevTimeTypeId == null ||
        response.processPrevTimeTypeName == null) {
      throw const MappingException();
    }

    return CommissionModel(
      id: response.id!,
      createdDate: response.createdDate!,
      updatedDate: response.updatedDate,
      defaultAmount: response.defaultAmount!,
      isActive: response.isActive!,
      isCustom: response.isCustom!,
      defaultCommissionMoneyTypeId: response.defaultCommissionMoneyTypeId!,
      defaultCommissionMoneyTypeName: response.defaultCommissionMoneyTypeName!,
      customerTypeId: response.customerTypeId!,
      customerTypeName: response.customerTypeName!,
      transferOperationTypeId: response.transferOperationTypeId!,
      transferOperationTypeName: response.transferOperationTypeName!,
      prevProcessCount: response.prevProcessCount!,
      processPrevMoneyTypeId: response.processPrevMoneyTypeId!,
      processPrevMoneyTypeName: response.processPrevMoneyTypeName!,
      processPrevMoney: response.processPrevMoney!,
      commissionFromTypeId: response.commissionFromTypeId!,
      commissionFromTypeName: response.commissionFromTypeName!,
      processPrevTimeTypeId: response.processPrevTimeTypeId!,
      processPrevTimeTypeName: response.processPrevTimeTypeName!,
    );
  }
}
