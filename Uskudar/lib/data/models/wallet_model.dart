import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/wallet_response.dart';
import 'package:payinall/domain/entities/wallet.dart';

final class WalletModel extends Wallet {
  const WalletModel({
    required super.balance,
    required super.availableBalance,
    required super.blockBalance,
  });

  factory WalletModel.fromResponse(WalletResponse response) {
    if (response.balance == null ||
        response.availableBalance == null ||
        response.blockBalance == null) {
      throw const MappingException();
    }

    return WalletModel(
      balance: response.balance!,
      availableBalance: response.availableBalance!,
      blockBalance: response.blockBalance!,
    );
  }
}
