part of 'email_verification_bloc.dart';

enum EmailVerificationBlocStatus {
  initial,
  loading,
  loaded,
  processing,
  success,
  error,
}

final class EmailVerificationState extends Equatable {
  const EmailVerificationState({
    this.status = EmailVerificationBlocStatus.initial,
    this.key,
    this.message,
    this.processCode,
  });

  final EmailVerificationBlocStatus status;
  final String? key;
  final String? message;
  final String? processCode;

  EmailVerificationState copyWith({
    EmailVerificationBlocStatus? status,
    String? key,
    String? message,
    String? processCode,
  }) {
    return EmailVerificationState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      processCode: processCode ?? this.processCode,
    );
  }

  @override
  List<Object?> get props => [status, message, processCode, key];
}
