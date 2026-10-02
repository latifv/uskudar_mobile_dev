import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/wallet_transfer_response.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';

final class WalletTransferModel extends WalletTransfer {
  const WalletTransferModel({
    required super.buyerFullName,
    required super.buyerInfo,
    required super.amount,
    required super.commissionAmount,
    required super.commissionFrom,
    required super.transactionNumber,
  });

  factory WalletTransferModel.fromResponse(WalletTransferResponse response) {
    final buyerFullName = response.buyerFullName ?? response.merchantName;
    final buyerInfo = response.buyerInfo ?? response.customerNumber;

    if (buyerFullName == null ||
        buyerInfo == null ||
        response.amount == null ||
        response.commissionAmount == null ||
        response.commissionFrom == null ||
        response.transactionNumber == null) {
      throw const MappingException();
    }

    return WalletTransferModel(
      buyerFullName: buyerFullName,
      buyerInfo: buyerInfo,
      amount: response.amount!,
      commissionAmount: response.commissionAmount!,
      commissionFrom: response.commissionFrom!,
      transactionNumber: response.transactionNumber!,
    );
  }
}
