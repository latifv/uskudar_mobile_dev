sealed class ScoringQuestionsEvent {
  const ScoringQuestionsEvent();
}

final class ScoringQuestionsSubmit extends ScoringQuestionsEvent {
  const ScoringQuestionsSubmit({
    required this.workType,
    required this.profession,
    required this.income,
    required this.monthlyTransactionCount,
    required this.incomeSource,
  });

  final int workType;
  final int profession;
  final int income;
  final int monthlyTransactionCount;
  final int incomeSource;
}

final class GetConstantsData extends ScoringQuestionsEvent {
  const GetConstantsData();
}

final class ScoringQuestionsUpdateWorkType extends ScoringQuestionsEvent {
  const ScoringQuestionsUpdateWorkType({required this.workType});

  final int workType;
}

final class ScoringQuestionsUpdateProfession extends ScoringQuestionsEvent {
  const ScoringQuestionsUpdateProfession({required this.profession});

  final int profession;
}

final class ScoringQuestionsUpdateIncome extends ScoringQuestionsEvent {
  const ScoringQuestionsUpdateIncome({required this.income});

  final int income;
}

final class ScoringQuestionsUpdateMonthlyTransaction
    extends ScoringQuestionsEvent {
  const ScoringQuestionsUpdateMonthlyTransaction({
    required this.monthlyTransactionCount,
  });

  final int monthlyTransactionCount;
}

final class ScoringQuestionsUpdateIncomeSource extends ScoringQuestionsEvent {
  const ScoringQuestionsUpdateIncomeSource({required this.incomeSource});

  final int incomeSource;
}
