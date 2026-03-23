part of 'add_bank_account_bloc.dart';

enum AddBankAccountBlocState { initial, processing, success, error }

final class AddBankAccountState extends Equatable {
  const AddBankAccountState({
    this.message,
    this.account,
    this.state = AddBankAccountBlocState.initial,
  });
  final AddBankAccountBlocState state;
  final String? message;
  final CustomerBank? account;

  AddBankAccountState copyWith({
    AddBankAccountBlocState? state,
    String? message,
    CustomerBank? account,
  }) {
    return AddBankAccountState(
      state: state ?? this.state,
      message: message,
      account: account ?? this.account,
    );
  }

  @override
  List<Object?> get props => [state, message, account];
}
