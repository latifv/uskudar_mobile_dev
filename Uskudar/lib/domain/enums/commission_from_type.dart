enum CommissionFromType {
  sender(1),
  buyer(2);

  const CommissionFromType(this.value);
  final int value;

  static CommissionFromType fromValue(int value) {
    return CommissionFromType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Argument exception CommissionFromType value: $value',
      ),
    );
  }
}
