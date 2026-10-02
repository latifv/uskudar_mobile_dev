part of 'login_bloc.dart';

enum LoginBlocStatus {
  initial,
  processing,
  smsVerification,
  success,
  newPassword,
  error,
}

final class LoginState extends Equatable {
  const LoginState({
    this.status = LoginBlocStatus.initial,
    this.phoneNumber,
    this.message,
    this.activationProcessCode,
    this.loginType = LoginType.individual,
  });
  final LoginBlocStatus status;
  final String? phoneNumber;
  final String? message;
  final String? activationProcessCode;
  final LoginType loginType;

  LoginState copyWith({
    LoginBlocStatus? status,
    String? phoneNumber,
    String? message,
    String? activationProcessCode,
    LoginType? loginType,
  }) {
    return LoginState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message,
      activationProcessCode:
          activationProcessCode ?? this.activationProcessCode,
      loginType: loginType ?? this.loginType,
    );
  }

  @override
  List<Object?> get props => [
    status,
    phoneNumber,
    message,
    activationProcessCode,
    loginType,
  ];
}
