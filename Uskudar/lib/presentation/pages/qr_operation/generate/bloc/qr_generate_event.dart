part of 'qr_generate_bloc.dart';

sealed class QrGenerateEvent {
  const QrGenerateEvent();
}

final class QrGenerateFormSubmitted extends QrGenerateEvent {
  const QrGenerateFormSubmitted({
    required this.amount,
    required this.walletAddress,
    this.qrColor,
  });

  final double amount;
  final String walletAddress;
  final Color? qrColor;
}
