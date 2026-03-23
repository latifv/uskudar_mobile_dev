import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/withdraw_transfer_response.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';

final class WithdrawTransferModel extends WithdrawTransfer {
  const WithdrawTransferModel({
    required super.fullName,
    required super.ibanNumber,
    required super.amount,
    required super.commissionAmount,
    required super.commissionFrom,
    required super.transactionNumber,
  });

  factory WithdrawTransferModel.fromResponse(
    WithdrawTransferResponse response,
  ) {
    if (response.fullName == null ||
        response.ibanNumber == null ||
        response.amount == null ||
        response.commissionAmount == null ||
        response.commissionFrom == null ||
        response.transactionNumber == null) {
      throw const MappingException();
    }

    return WithdrawTransferModel(
      fullName: response.fullName!,
      ibanNumber: response.ibanNumber!,
      amount: response.amount!,
      commissionAmount: response.commissionAmount!,
      commissionFrom: response.commissionFrom!,
      transactionNumber: response.transactionNumber!,
    );
  }
}
