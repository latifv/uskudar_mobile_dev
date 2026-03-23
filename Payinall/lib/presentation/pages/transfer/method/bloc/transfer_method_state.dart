part of 'transfer_method_bloc.dart';

enum TransferMethodStatus { initial, loading, loaded, error }

final class TransferMethodState extends Equatable {
  const TransferMethodState({
    this.status = TransferMethodStatus.initial,
    this.method,
    this.walletAddress,
    this.phone,
    this.selectedBankAccount,
    this.bankAccounts = const [],
    this.frequentIbans = const [],
    this.frequentlySents = const [],
    this.message,
  });

  final TransferMethodStatus status;
  final TransferMethod? method;
  final String? walletAddress;
  final String? phone;
  final CustomerBank? selectedBankAccount;
  final List<CustomerBank> bankAccounts;
  final List<FrequentIban> frequentIbans;
  final List<FrequentlySent> frequentlySents;
  final String? message;

  TransferMethodState copyWith({
    TransferMethodStatus? status,
    TransferMethod? method,
    String? walletAddress,
    String? phone,
    CustomerBank? selectedBankAccount,
    List<CustomerBank>? bankAccounts,
    List<FrequentIban>? frequentIbans,
    List<FrequentlySent>? frequentlySents,
    String? message,
  }) {
    return TransferMethodState(
      status: status ?? this.status,
      method: method ?? this.method,
      walletAddress: walletAddress,
      phone: phone,
      selectedBankAccount: selectedBankAccount,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      frequentIbans: frequentIbans ?? this.frequentIbans,
      frequentlySents: frequentlySents ?? this.frequentlySents,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    method,
    walletAddress,
    phone,
    selectedBankAccount,
    bankAccounts,
    frequentIbans,
    frequentlySents,
    message,
  ];
}
