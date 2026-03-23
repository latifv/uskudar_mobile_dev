class RequestMoneyParams {
  const RequestMoneyParams({
    required this.money,
    required this.description,
    required this.fromAddress,
  });

  final double money;
  final String description;
  final String fromAddress;
}
