part of 'wrong_login_attempts_bloc.dart';

enum WrongLoginAttemptsStatus { initial, loading, loaded, error }

final class WrongLoginAttemptsState extends Equatable {
  const WrongLoginAttemptsState({
    this.status = WrongLoginAttemptsStatus.initial,
    this.wrongPasswordHistories,
    this.message,
    this.key,
  });

  final Key? key;
  final WrongLoginAttemptsStatus status;
  final List<WrongPasswordHistory>? wrongPasswordHistories;
  final String? message;

  WrongLoginAttemptsState copyWith({
    WrongLoginAttemptsStatus? status,
    List<WrongPasswordHistory>? wrongPasswordHistories,
    String? message,
    Key? key,
  }) {
    return WrongLoginAttemptsState(
      status: status ?? this.status,
      wrongPasswordHistories:
          wrongPasswordHistories ?? this.wrongPasswordHistories,
      message: message,
      key: key ?? this.key,
    );
  }

  @override
  List<Object?> get props => [status, wrongPasswordHistories, message, key];
}
