class AppBank {
  AppBank({
    required this.id,
    required this.bankId,
    required this.bankName,
    required this.iban,
    required this.order,
    required this.isActive,
  });

  final int id;
  final int bankId;
  final String bankName;
  final String iban;
  final int order;
  final bool isActive;

  String get imageUrl => 'assets/icons/ic_bank_$bankId.png';
}
