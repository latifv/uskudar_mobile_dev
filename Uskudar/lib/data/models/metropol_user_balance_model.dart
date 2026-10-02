import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/metropol_user_balance_response.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_balance.dart';

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
