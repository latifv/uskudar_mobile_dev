part of 'security_forgot_password_bloc.dart';

enum SecurityForgotPasswordStatus { initial, processing, success, error }

final class SecurityForgotPasswordState extends Equatable {
  const SecurityForgotPasswordState({
    this.message,
    this.status = SecurityForgotPasswordStatus.initial,
    this.question,
    this.loginType = LoginType.individual,
  });

  final String? message;
  final SecurityForgotPasswordStatus status;
  final String? question;
  final LoginType loginType;
  SecurityForgotPasswordState copyWith({
    String? message,
    SecurityForgotPasswordStatus? status,
    String? question,
    LoginType? loginType,
  }) {
    return SecurityForgotPasswordState(
      message: message,
      status: status ?? this.status,
      question: question,
      loginType: loginType ?? this.loginType,
    );
  }

  @override
  List<Object?> get props => [message, status, question, loginType];
}
