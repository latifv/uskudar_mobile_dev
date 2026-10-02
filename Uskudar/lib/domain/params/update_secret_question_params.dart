final class UpdateSecretQuestionParams {
  const UpdateSecretQuestionParams({
    required this.userQuestionId,
    required this.secretQuestion,
  });

  final int userQuestionId;
  final String secretQuestion;
}
