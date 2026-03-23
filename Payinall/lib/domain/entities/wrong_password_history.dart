class WrongPasswordHistory {
  const WrongPasswordHistory({
    required this.createdDate,
    required this.ipAddress,
  });

  final DateTime createdDate;
  final String ipAddress;
}
