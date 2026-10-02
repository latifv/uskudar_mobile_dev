part of 'back_id_scan_bloc.dart';

sealed class BackIdScanEvent {
  const BackIdScanEvent();
}

final class BackIdScanStart extends BackIdScanEvent {
  const BackIdScanStart();
}

final class BackIdScanEnd extends BackIdScanEvent {
  const BackIdScanEnd({required this.processId, this.image});

  final String? image;
  final String processId;
}
