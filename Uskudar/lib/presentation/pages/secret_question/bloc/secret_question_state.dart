part of 'secret_question_bloc.dart';

enum SecretQuestionStatus {
  initial,
  loading,
  loaded,
  submitting,
  success,
  error,
}

final class SecretQuestionState extends Equatable {
  const SecretQuestionState({
    this.status = SecretQuestionStatus.initial,
    this.userQuestions = const [],
    this.message,
  });

  final SecretQuestionStatus status;
  final List<UserQuestion> userQuestions;
  final String? message;

  SecretQuestionState copyWith({
    SecretQuestionStatus? status,
    List<UserQuestion>? userQuestions,
    String? message,
  }) {
    return SecretQuestionState(
      status: status ?? this.status,
      userQuestions: userQuestions ?? this.userQuestions,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, userQuestions, message];
}
