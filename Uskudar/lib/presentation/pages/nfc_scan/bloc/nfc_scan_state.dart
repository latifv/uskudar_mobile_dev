part of 'nfc_scan_bloc.dart';

enum NfcScanStatus { initial, loading, loaded, success, error }

final class NfcScanState extends Equatable {
  const NfcScanState({
    this.status = NfcScanStatus.initial,
    this.key,
    this.message,
    this.nfcData,
    this.image,
  });

  final NfcScanStatus status;
  final Key? key;
  final String? message;
  final NfcIdentity? nfcData;
  final String? image;

  NfcScanState copyWith({
    NfcScanStatus? status,
    Key? key,
    String? message,
    NfcIdentity? nfcData,
    String? image,
  }) {
    return NfcScanState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      nfcData: nfcData ?? this.nfcData,
      image: image ?? this.image,
    );
  }

  @override
  List<Object?> get props => [status, key, message, nfcData, image];
}
