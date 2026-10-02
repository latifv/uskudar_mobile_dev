import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';

enum BankDetailStatus { initial, loading, loaded, error }

final class BankDetailState extends Equatable {
  const BankDetailState({
    this.status = BankDetailStatus.initial,
    this.bank,
    this.walletAddress,
    this.message,
    this.key,
  });

  final Key? key;
  final BankDetailStatus status;
  final AppBank? bank;
  final String? walletAddress;
  final String? message;

  BankDetailState copyWith({
    Key? key,
    BankDetailStatus? status,
    AppBank? bank,
    String? walletAddress,
    String? message,
  }) {
    return BankDetailState(
      key: key ?? this.key,
      status: status ?? this.status,
      bank: bank ?? this.bank,
      walletAddress: walletAddress ?? this.walletAddress,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, bank, walletAddress, message];
}
