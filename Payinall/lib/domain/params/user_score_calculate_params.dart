class UserScoreCalculateParams {
  const UserScoreCalculateParams({
    required this.businessTypeId,
    required this.jobId,
    required this.presenceSourceId,
    required this.monthlyTransactionCountTypeId,
    required this.averageRevenueTypeId,
  });

  final int businessTypeId;
  final int jobId;
  final int presenceSourceId;
  final int monthlyTransactionCountTypeId;
  final int averageRevenueTypeId;
}
