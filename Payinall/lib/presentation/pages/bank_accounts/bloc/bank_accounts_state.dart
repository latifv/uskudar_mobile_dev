part of 'bank_accounts_bloc.dart';

sealed class BankAccountsState extends Equatable {
  const BankAccountsState();

  @override
  List<Object?> get props => [];
}

final class BankAccountsInitial extends BankAccountsState {}

final class BankAccountsLoading extends BankAccountsState {}

final class BankAccountsLoaded extends BankAccountsState {
  const BankAccountsLoaded({required this.accounts});

  final List<CustomerBank> accounts;

  @override
  List<Object?> get props => [accounts];
}

final class BankAccountsError extends BankAccountsState {
  const BankAccountsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
