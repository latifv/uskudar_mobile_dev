part of 'transfer_amount_bloc.dart';

sealed class TransferAmountEvent {
  const TransferAmountEvent();
}

final class TransferAmountEntered extends TransferAmountEvent {
  const TransferAmountEntered({required this.amount});

  final double amount;
}

final class TransferAmountSubmitted extends TransferAmountEvent {
  const TransferAmountSubmitted({
    required this.transferMethod,
    required this.amount,
    this.phone,
    this.walletAddress,
    this.iban,
    this.description,
  });

  final TransferMethod transferMethod;
  final String? phone;
  final String? walletAddress;
  final String? iban;
  final String? description;
  final double amount;
}
