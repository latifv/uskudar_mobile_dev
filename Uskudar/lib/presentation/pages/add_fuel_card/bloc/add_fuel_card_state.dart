part of 'add_fuel_card_bloc.dart';

enum AddFuelCardStatus { initial, loading, success, error }

final class AddFuelCardState extends Equatable {
  const AddFuelCardState({
    this.status = AddFuelCardStatus.initial,
    this.message,
  });

  final AddFuelCardStatus status;
  final String? message;

  AddFuelCardState copyWith({
    AddFuelCardStatus? status,
    String? message,
  }) {
    return AddFuelCardState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
