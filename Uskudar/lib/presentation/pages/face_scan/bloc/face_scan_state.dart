part of 'face_scan_bloc.dart';

enum FaceScanStatus { initial, agreementsCompleted, loading, success, error }

final class FaceScanState extends Equatable {
  const FaceScanState({
    this.status = FaceScanStatus.initial,
    this.key,
    this.message,
  });

  final FaceScanStatus status;
  final Key? key;
  final String? message;

  FaceScanState copyWith({FaceScanStatus? status, Key? key, String? message}) {
    return FaceScanState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, key, message];
}
