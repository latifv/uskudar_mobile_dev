part of 'password_confirmation_bloc.dart';

enum PasswordConfirmationStatus {
  initial,
  processing,
  success,
  error,
  logoutSuccess,
  smsVerification,
}

final class PasswordConfirmationState extends Equatable {
  const PasswordConfirmationState({
    this.status = PasswordConfirmationStatus.initial,
    this.message,
    this.activationProcessCode,
  });

  final PasswordConfirmationStatus status;
  final String? message;
  final String? activationProcessCode;

  PasswordConfirmationState copyWith({
    PasswordConfirmationStatus? status,
    String? message,
    String? activationProcessCode,
  }) {
    return PasswordConfirmationState(
      status: status ?? this.status,
      message: message,
      activationProcessCode:
          activationProcessCode ?? this.activationProcessCode,
    );
  }

  @override
  List<Object?> get props => [status, message, activationProcessCode];
}
