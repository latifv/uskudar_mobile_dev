part of 'account_limits_bloc.dart';

enum AccountLimitsStatus { initial, loading, loaded, error }

final class AccountLimitsState extends Equatable {
  const AccountLimitsState({
    this.status = AccountLimitsStatus.initial,
    this.limits,
    this.message,
  });

  final AccountLimitsStatus status;
  final List<CustomerProcess>? limits;
  final String? message;

  AccountLimitsState copyWith({
    AccountLimitsStatus? status,
    List<CustomerProcess>? limits,
    String? message,
  }) {
    return AccountLimitsState(
      status: status ?? this.status,
      limits: limits ?? this.limits,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, limits, message];
}
