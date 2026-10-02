import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/transaction_response.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';

final class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.amount,
    required super.commissionAmount,
    required super.commissionType,
    required super.description,
    required super.transferType,
    required super.statusName,
    required super.fromFullName,
    required super.date,
    super.fromAddress,
    super.toCustomerNumber,
    super.toFullName,
    super.transactionTypes,
    super.commissionFromType,
    super.oldBalance,
    super.newBalance,
  });

  factory TransactionModel.fromResponse(TransactionResponse response) {
    if (response.id == null ||
        response.amount == null ||
        response.commissionAmount == null ||
        response.commissionType == null ||
        response.description == null ||
        response.transferType == null ||
        response.statusName == null ||
        response.fromFullName == null ||
        response.date == null) {
      throw const MappingException();
    }

    return TransactionModel(
      id: response.id!,
      amount: response.amount!,
      commissionAmount: response.commissionAmount!,
      commissionType: response.commissionType!,
      description: response.description!,
      transferType: response.transferType!,
      statusName: response.statusName!,
      fromFullName: response.fromFullName!,
      toFullName: response.toFullName,
      date: response.date!,
      toCustomerNumber: response.toCustomerNumber,
      fromAddress: response.fromAddress,
      transactionTypes: response.transactionTypes,
      commissionFromType: response.commissionFromType,
      oldBalance: response.oldBalance,
      newBalance: response.newBalance,
    );
  }
}
