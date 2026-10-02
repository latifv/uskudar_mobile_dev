part of 'change_email_bloc.dart';

enum ChangeEmailStatus {
  initial,
  loading,
  success,
  error,
}

final class ChangeEmailState extends Equatable {
  const ChangeEmailState({
    this.status = ChangeEmailStatus.initial,
    this.message,
    this.processCode,
  });

  final ChangeEmailStatus status;
  final String? message;
  final String? processCode;

  ChangeEmailState copyWith({
    ChangeEmailStatus? status,
    String? message,
    String? processCode,
  }) {
    return ChangeEmailState(
      status: status ?? this.status,
      message: message,
      processCode: processCode ?? this.processCode,
    );
  }

  @override
  List<Object?> get props => [status, message, processCode];
}
