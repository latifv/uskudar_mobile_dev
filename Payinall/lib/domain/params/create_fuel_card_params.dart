class CreateFuelCardParams {
  const CreateFuelCardParams({
    required this.cardNo,
    required this.cardType,
    this.plate,
    this.fuelType,
  });

  final String cardNo;
  final int cardType;
  final String? plate;
  final int? fuelType;
}
