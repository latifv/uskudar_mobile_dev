part of 'qr_generate_bloc.dart';

sealed class QrGenerateState extends Equatable {
  const QrGenerateState();

  @override
  List<Object?> get props => [];
}

final class QrGenerateInitial extends QrGenerateState {
  const QrGenerateInitial();
}

final class QrGenerateLoading extends QrGenerateState {
  const QrGenerateLoading();
}

final class QrGenerateSuccess extends QrGenerateState {
  const QrGenerateSuccess({required this.qrImage, required this.amount});

  final Uint8List qrImage;
  final double amount;

  @override
  List<Object?> get props => [qrImage, amount];
}

final class QrGenerateError extends QrGenerateState {
  const QrGenerateError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
