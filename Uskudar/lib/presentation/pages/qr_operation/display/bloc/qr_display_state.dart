part of 'qr_display_bloc.dart';

sealed class QrDisplayState extends Equatable {
  const QrDisplayState();

  @override
  List<Object?> get props => [];
}

final class QrDisplayInitial extends QrDisplayState {
  const QrDisplayInitial();
}

final class QrDisplayLoaded extends QrDisplayState {
  const QrDisplayLoaded({required this.qrImage, required this.amount});

  final Uint8List qrImage;
  final double amount;

  @override
  List<Object?> get props => [qrImage, amount];
}
