part of 'fuel_cards_bloc.dart';

enum FuelCardsStatus { initial, loading, loaded, deleting, deleted, error }

final class FuelCardsState extends Equatable {
  const FuelCardsState({
    this.status = FuelCardsStatus.initial,
    this.cards = const [],
    this.balances = const {},
    this.message,
    this.successMessage,
  });

  final FuelCardsStatus status;
  final List<FuelCard> cards;
  final Map<int, double> balances;
  final String? message;
  final String? successMessage;

  FuelCardsState copyWith({
    FuelCardsStatus? status,
    List<FuelCard>? cards,
    Map<int, double>? balances,
    String? message,
    String? successMessage,
  }) {
    return FuelCardsState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      balances: balances ?? this.balances,
      message: message,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, cards, balances, message, successMessage];
}
