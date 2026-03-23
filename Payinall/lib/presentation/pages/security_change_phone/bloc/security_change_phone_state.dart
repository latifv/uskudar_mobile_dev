part of 'security_change_phone_bloc.dart';

enum SecurityChangePhoneStatus { initial, loading, success, error }

final class SecurityChangePhoneState extends Equatable {
  const SecurityChangePhoneState({
    this.message,
    this.status = SecurityChangePhoneStatus.initial,
    this.key,
    this.question,
  });

  final String? message;
  final SecurityChangePhoneStatus status;
  final Key? key;
  final String? question;
  SecurityChangePhoneState copyWith({
    String? message,
    SecurityChangePhoneStatus? status,
    Key? key,
    String? question,
  }) {
    return SecurityChangePhoneState(
      message: message,
      status: status ?? this.status,
      key: key ?? this.key,
      question: question,
    );
  }

  @override
  List<Object?> get props => [message, status, key, question];
}
