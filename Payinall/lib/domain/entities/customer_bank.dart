class CustomerBank {
  const CustomerBank({
    required this.bankId,
    required this.bankName,
    required this.iban,
    required this.title,
  });

  final int bankId;
  final String bankName;
  final String iban;
  final String title;
}
