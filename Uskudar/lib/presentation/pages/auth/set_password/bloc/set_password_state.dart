part of 'set_password_bloc.dart';

enum SetPasswordStatus { initial, processing, success, error }

final class SetPasswordState extends Equatable {
  const SetPasswordState({
    this.status = SetPasswordStatus.initial,
    this.message,
  });
  final SetPasswordStatus status;
  final String? message;

  SetPasswordState copyWith({SetPasswordStatus? status, String? message}) {
    return SetPasswordState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}
