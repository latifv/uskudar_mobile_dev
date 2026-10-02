part of 'reset_password_bloc.dart';

enum ResetPasswordStatus { initial, processing, success, error }

final class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.message,
  });

  final ResetPasswordStatus status;
  final String? message;

  ResetPasswordState copyWith({ResetPasswordStatus? status, String? message}) {
    return ResetPasswordState(status: status ?? this.status, message: message);
  }

  @override
  List<Object?> get props => [status, message];
}
