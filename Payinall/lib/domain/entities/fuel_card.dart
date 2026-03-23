class FuelCard {
  const FuelCard({
    required this.id,
    required this.cardNo,
    required this.isActive,
    required this.cardType,
    required this.cardTypeName,
    required this.createdDate,
  });

  final int id;
  final String cardNo;
  final bool isActive;
  final int cardType;
  final String cardTypeName;
  final String createdDate;
}
