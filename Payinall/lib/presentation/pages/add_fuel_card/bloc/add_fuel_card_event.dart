part of 'add_fuel_card_bloc.dart';

sealed class AddFuelCardEvent {
  const AddFuelCardEvent();
}

final class AddFuelCardSubmit extends AddFuelCardEvent {
  const AddFuelCardSubmit({
    required this.cardNo,
    required this.cardType,
    this.plate,
    this.fuelType,
  });

  final String cardNo;
  final int cardType;
  final String? plate;
  final int? fuelType;
}
