part of 'nfc_scan_bloc.dart';

sealed class NfcScanEvent {
  const NfcScanEvent();
}

final class NfcScanStart extends NfcScanEvent {
  const NfcScanStart();
}

final class NfcScanEnd extends NfcScanEvent {
  const NfcScanEnd({
    required this.processId,
    required this.nfcData,
    required this.mrz,
  });

  final String processId;
  final NfcIdentity? nfcData;
  final String mrz;
}
