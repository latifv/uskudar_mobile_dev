import 'package:equatable/equatable.dart';

enum ReceiveMoneyStatus { initial, loading, success, error }

final class ReceiveMoneyState extends Equatable {
  const ReceiveMoneyState({
    this.status = ReceiveMoneyStatus.initial,
    this.message,
  });

  final ReceiveMoneyStatus status;
  final String? message;

  ReceiveMoneyState copyWith({
    ReceiveMoneyStatus? status,
    String? message,
  }) {
    return ReceiveMoneyState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
