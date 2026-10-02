import 'package:uskudar_mobile/data/dtos/responses/wallet_operator_response.dart';
import 'package:uskudar_mobile/domain/entities/wallet_operator.dart';

class WalletOperatorModel extends WalletOperator {
  const WalletOperatorModel({
    required super.operatorCode,
    required super.operatorName,
    required super.senderCurrencyType,
  });

  factory WalletOperatorModel.fromResponse(WalletOperatorResponse response) {
    return WalletOperatorModel(
      operatorCode: response.operatorCode,
      operatorName: response.operatorName,
      senderCurrencyType: response.senderCurrencyType,
    );
  }
}
