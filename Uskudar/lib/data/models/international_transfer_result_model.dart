import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/international_transfer_result_response.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';

final class InternationalTransferResultModel
    extends InternationalTransferResult {
  const InternationalTransferResultModel({
    required super.toFullName,
    required super.toInfo,
    required super.amount,
    required super.commissionAmount,
    required super.commissionFrom,
    required super.transactionNumber,
    required super.receivedPaymentAmount,
    required super.receivedPaymentAmountCurrency,
  });

  factory InternationalTransferResultModel.fromResponse(
    InternationalTransferResultResponse response,
  ) {
    if (response.toFullName == null ||
        response.toInfo == null ||
        response.amount == null ||
        response.commissionAmount == null ||
        response.commissionFrom == null ||
        response.transactionNumber == null ||
        response.receivedPaymentAmount == null ||
        response.receivedPaymentAmountCurrency == null) {
      throw const MappingException();
    }

    return InternationalTransferResultModel(
      toFullName: response.toFullName!,
      toInfo: response.toInfo!,
      amount: response.amount!,
      commissionAmount: response.commissionAmount!,
      commissionFrom: response.commissionFrom!,
      transactionNumber: response.transactionNumber!,
      receivedPaymentAmount: response.receivedPaymentAmount!,
      receivedPaymentAmountCurrency: response.receivedPaymentAmountCurrency!,
    );
  }
}
