import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/merchant_wallet_response.dart';
import 'package:uskudar_mobile/domain/entities/merchant_wallet.dart';

final class MerchantWalletModel extends MerchantWallet {
  const MerchantWalletModel({
    required super.id,
    required super.customerNumber,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.merchantId,
    required super.merchantCompanyName,
    required super.balance,
    required super.blockBalance,
    required super.availableBalance,
    required super.isWalletLocked,
  });

  factory MerchantWalletModel.fromResponse(MerchantWalletResponse response) {
    if (response.id == null ||
        response.customerNumber == null ||
        response.firstName == null ||
        response.lastName == null ||
        response.email == null ||
        response.merchantId == null ||
        response.merchantCompanyName == null ||
        response.balance == null ||
        response.blockBalance == null ||
        response.availableBalance == null ||
        response.isWalletLocked == null) {
      throw const MappingException();
    }
    return MerchantWalletModel(
      id: response.id!,
      customerNumber: response.customerNumber!,
      firstName: response.firstName!,
      lastName: response.lastName!,
      email: response.email!,
      merchantId: response.merchantId!,
      merchantCompanyName: response.merchantCompanyName!,
      balance: response.balance!,
      blockBalance: response.blockBalance!,
      availableBalance: response.availableBalance!,
      isWalletLocked: response.isWalletLocked!,
    );
  }
}
