part of 'qr_scan_bloc.dart';

sealed class QrScanState extends Equatable {
  const QrScanState();

  @override
  List<Object?> get props => [];
}

final class QrScanInitial extends QrScanState {
  const QrScanInitial();
}

final class QrScanLoading extends QrScanState {
  const QrScanLoading();
}

final class QrScanReady extends QrScanState {
  const QrScanReady();
}

final class QrScanScanning extends QrScanState {
  const QrScanScanning();
}

final class QrScanSuccess extends QrScanState {
  const QrScanSuccess({required this.data});

  final String data;

  @override
  List<Object?> get props => [data];
}

final class QrScanError extends QrScanState {
  const QrScanError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class QrScanComplete extends QrScanState {
  const QrScanComplete();
}

final class QrScanPermissionRequired extends QrScanState {
  const QrScanPermissionRequired();
}

final class QrScanRequestingPermission extends QrScanState {
  const QrScanRequestingPermission();
}

final class QrScanPermissionDenied extends QrScanState {
  const QrScanPermissionDenied();
}
