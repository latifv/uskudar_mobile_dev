class CreateCustomerDemandParams {
  const CreateCustomerDemandParams({
    required this.requestSubjectId,
    required this.title,
    required this.content,
  });

  final int requestSubjectId;
  final String title;
  final String content;
}
