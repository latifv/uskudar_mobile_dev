import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';

enum BankListStatus { initial, loading, loaded, error }

final class BankListState extends Equatable {
  const BankListState({
    this.status = BankListStatus.initial,
    this.banks,
    this.selectedBankId,
    this.message,
    this.key,
  });

  final Key? key;
  final BankListStatus status;
  final List<AppBank>? banks;
  final int? selectedBankId;
  final String? message;

  BankListState copyWith({
    Key? key,
    BankListStatus? status,
    List<AppBank>? banks,
    int? selectedBankId,
    String? message,
  }) {
    return BankListState(
      key: key ?? this.key,
      status: status ?? this.status,
      banks: banks ?? this.banks,
      selectedBankId: selectedBankId ?? this.selectedBankId,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, banks, selectedBankId, message];
}
