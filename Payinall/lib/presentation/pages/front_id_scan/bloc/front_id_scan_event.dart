part of 'front_id_scan_bloc.dart';

sealed class FrontIdScanEvent {
  const FrontIdScanEvent();
}

final class FrontIdScanStart extends FrontIdScanEvent {
  const FrontIdScanStart();
}

final class FrontIdScanEnd extends FrontIdScanEvent {
  const FrontIdScanEnd({required this.image});

  final String? image;
}
