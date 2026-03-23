part of 'qr_scan_bloc.dart';

sealed class QrScanEvent {
  const QrScanEvent();
}

final class QrScanStarted extends QrScanEvent {
  const QrScanStarted();
}

final class QrScanDetected extends QrScanEvent {
  const QrScanDetected(this.data);

  final String data;
}

final class QrScanCancelled extends QrScanEvent {
  const QrScanCancelled();
}

final class QrScanPermissionRequested extends QrScanEvent {
  const QrScanPermissionRequested();
}

final class QrScanSessionStarted extends QrScanEvent {
  const QrScanSessionStarted();
}
