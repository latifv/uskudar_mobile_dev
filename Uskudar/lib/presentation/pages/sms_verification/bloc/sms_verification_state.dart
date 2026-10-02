part of 'sms_verification_bloc.dart';

enum SmsVerificationBlocStatus {
  initial,
  loading,
  loaded,
  processing,
  success,
  error,
}

final class SmsVerificationState extends Equatable {
  const SmsVerificationState({
    this.status = SmsVerificationBlocStatus.initial,
    this.key,
    this.message,
    this.processCode,
  });

  final SmsVerificationBlocStatus status;
  final String? key;
  final String? message;
  final String? processCode;

  SmsVerificationState copyWith({
    SmsVerificationBlocStatus? status,
    String? key,
    String? message,
    String? processCode,
  }) {
    return SmsVerificationState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      processCode: processCode ?? this.processCode,
    );
  }

  @override
  List<Object?> get props => [status, message, processCode, key];
}
