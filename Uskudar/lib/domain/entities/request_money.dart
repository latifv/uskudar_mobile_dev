class RequestMoney {
  const RequestMoney({
    required this.id,
    required this.fromAddress,
    required this.toAddress,
    required this.toUserName,
    required this.fromUserName,
    required this.amount,
    required this.description,
    required this.createdDate,
  });

  final int id;
  final String fromAddress;
  final String toAddress;
  final String toUserName;
  final String fromUserName;
  final double amount;
  final String description;
  final DateTime createdDate;
}
