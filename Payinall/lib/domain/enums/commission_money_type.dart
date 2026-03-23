enum CommissionMoneyType {
  ratio(1),
  amount(2);

  const CommissionMoneyType(this.value);
  final int value;
  static CommissionMoneyType fromValue(int value) {
    return CommissionMoneyType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError(
        'Argument Exceotion CommissionMoneyType value: $value',
      ),
    );
  }
}
