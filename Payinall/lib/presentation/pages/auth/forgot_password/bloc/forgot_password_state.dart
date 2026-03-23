part of 'forgot_password_bloc.dart';

enum ForgotPasswordStatus { initial, processing, success, error }

final class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.message,
    this.status = ForgotPasswordStatus.initial,
    this.phoneNumber,
  });

  final String? message;
  final ForgotPasswordStatus status;
  final String? phoneNumber;

  ForgotPasswordState copyWith({
    String? message,
    ForgotPasswordStatus? status,
    String? phoneNumber,
  }) {
    return ForgotPasswordState(
      message: message,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [message, status, phoneNumber];
}
