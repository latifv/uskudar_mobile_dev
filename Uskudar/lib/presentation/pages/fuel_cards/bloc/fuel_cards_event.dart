part of 'fuel_cards_bloc.dart';

sealed class FuelCardsEvent {
  const FuelCardsEvent();
}

final class FuelCardsLoad extends FuelCardsEvent {
  const FuelCardsLoad();
}

final class FuelCardDeleteRequested extends FuelCardsEvent {
  const FuelCardDeleteRequested({required this.cardId});

  final int cardId;
}
