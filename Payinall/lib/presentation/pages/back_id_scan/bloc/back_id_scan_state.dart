part of 'back_id_scan_bloc.dart';

enum BackIdScanStatus { initial, loading, loaded, success, error }

final class BackIdScanState extends Equatable {
  const BackIdScanState({
    this.status = BackIdScanStatus.initial,
    this.key,
    this.message,
  });

  final BackIdScanStatus status;
  final Key? key;
  final String? message;

  BackIdScanState copyWith({
    BackIdScanStatus? status,
    Key? key,
    String? message,
  }) {
    return BackIdScanState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, key, message];
}
