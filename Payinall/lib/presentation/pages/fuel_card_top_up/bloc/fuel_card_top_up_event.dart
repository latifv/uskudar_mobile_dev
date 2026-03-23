part of 'fuel_card_top_up_bloc.dart';

sealed class FuelCardTopUpEvent {
  const FuelCardTopUpEvent();
}

final class FuelCardTopUpLoadBalance extends FuelCardTopUpEvent {
  const FuelCardTopUpLoadBalance({required this.fuelCardId});

  final int fuelCardId;
}

final class FuelCardTopUpSubmit extends FuelCardTopUpEvent {
  const FuelCardTopUpSubmit({
    required this.fuelCardId,
    required this.amount,
  });

  final int fuelCardId;
  final double amount;
}
