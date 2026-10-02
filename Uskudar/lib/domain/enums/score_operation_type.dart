enum ScoreOperationType {
  businessType,
  job,
  presenceSource;

  const ScoreOperationType();
  int get value {
    switch (this) {
      case ScoreOperationType.businessType:
        return 2;
      case ScoreOperationType.job:
        return 3;
      case ScoreOperationType.presenceSource:
        return 5;
    }
  }
}
