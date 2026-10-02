part of 'register_bloc.dart';

enum RegisterBlocStatus { initial, processing, success, error }

final class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterBlocStatus.initial,
    this.key,
    this.message,
    this.processCode,
  });
  final RegisterBlocStatus status;
  final Key? key;
  final String? message;
  final String? processCode;

  RegisterState copyWith({
    RegisterBlocStatus? status,
    Key? key,
    String? message,
    String? processCode,
  }) {
    return RegisterState(
      status: status ?? this.status,
      key: key ?? this.key,
      message: message,
      processCode: processCode ?? this.processCode,
    );
  }

  @override
  List<Object?> get props => [status, message, processCode, key];
}
