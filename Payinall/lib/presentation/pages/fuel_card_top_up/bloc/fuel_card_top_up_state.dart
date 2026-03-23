part of 'fuel_card_top_up_bloc.dart';

enum FuelCardTopUpStatus {
  initial,
  loadingBalance,
  loaded,
  submitting,
  success,
  error,
}

final class FuelCardTopUpState extends Equatable {
  const FuelCardTopUpState({
    this.status = FuelCardTopUpStatus.initial,
    this.balance,
    this.message,
  });

  final FuelCardTopUpStatus status;
  final double? balance;
  final String? message;

  FuelCardTopUpState copyWith({
    FuelCardTopUpStatus? status,
    double? balance,
    String? message,
  }) {
    return FuelCardTopUpState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, balance, message];
}
