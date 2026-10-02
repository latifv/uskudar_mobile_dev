import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/metropol_transaction_response.dart';
import 'package:uskudar_mobile/domain/entities/metropol_transaction.dart';

final class MetropolTransactionModel extends MetropolTransaction {
  const MetropolTransactionModel({
    required super.cardNo,
    required super.personnelNo,
    required super.transactionId,
    required super.transactionInfo,
    required super.transactionDate,
    required super.amount,
    required super.walletId,
    required super.walletName,
    required super.merchantName,
    required super.dayCount,
    required super.paymentTypeId,
  });

  factory MetropolTransactionModel.fromResponse(
    MetropolTransactionResponse response,
  ) {
    if (response.transactionId == null || response.transactionDate == null) {
      throw const MappingException();
    }

    return MetropolTransactionModel(
      cardNo: response.cardNo ?? '',
      personnelNo: response.personnelNo ?? '',
      transactionId: response.transactionId!,
      transactionInfo: response.transactionInfo ?? '',
      transactionDate: response.transactionDate!,
      amount: response.amount ?? '',
      walletId: response.walletId ?? '',
      walletName: response.walletName ?? '',
      merchantName: response.merchantName ?? '',
      dayCount: response.dayCount ?? 0,
      paymentTypeId: response.paymentTypeId ?? 0,
    );
  }
}
