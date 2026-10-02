part of 'qr_display_bloc.dart';

sealed class QrDisplayEvent {
  const QrDisplayEvent();
}

final class QrDisplayLoadData extends QrDisplayEvent {
  const QrDisplayLoadData({required this.qrImage, required this.amount});

  final Uint8List qrImage;
  final double amount;
}
