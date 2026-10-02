import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/metropol_user_balance_response.dart';
import 'package:payinall/domain/entities/metropol_user_balance.dart';

final class MetropolUserBalanceModel extends MetropolUserBalance {
  const MetropolUserBalanceModel({
    required super.restoBalance,
    required super.giftBalance,
  });

  factory MetropolUserBalanceModel.fromResponse(
    MetropolUserBalanceResponse response,
  ) {
    if (response.restoBalance == null || response.giftBalance == null) {
      throw const MappingException();
    }

    return MetropolUserBalanceModel(
      restoBalance: response.restoBalance!,
      giftBalance: response.giftBalance!,
    );
  }
}
