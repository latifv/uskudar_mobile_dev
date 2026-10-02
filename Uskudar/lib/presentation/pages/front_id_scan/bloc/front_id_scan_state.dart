part of 'front_id_scan_bloc.dart';

enum FrontIdScanStatus { initial, loading, loaded, success, error }

final class FrontIdScanState extends Equatable {
  const FrontIdScanState({
    this.status = FrontIdScanStatus.initial,
    this.key,
    this.message,
    this.processId,
  });

  final FrontIdScanStatus status;
  final Key? key;
  final String? message;
  final String? processId;
  FrontIdScanState copyWith({
    FrontIdScanStatus? status,
    Key? key,
    String? message,
    String? processId,
  }) {
    return FrontIdScanState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      processId: processId ?? this.processId,
    );
  }

  @override
  List<Object?> get props => [status, key, message, processId];
}
