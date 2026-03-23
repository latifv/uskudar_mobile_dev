part of 'secret_question_bloc.dart';

sealed class SecretQuestionEvent {
  const SecretQuestionEvent();
}

final class SecretQuestionLoadQuestions extends SecretQuestionEvent {
  const SecretQuestionLoadQuestions();
}

final class SecretQuestionSubmit extends SecretQuestionEvent {
  const SecretQuestionSubmit({
    required this.userQuestionId,
    required this.secretQuestion,
  });

  final int userQuestionId;
  final String secretQuestion;
}
