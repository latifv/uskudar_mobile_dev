class MerchantWithdrawTransferParams {
  const MerchantWithdrawTransferParams({
    required this.ibanNumber,
    required this.amount,
    required this.firstName,
    required this.lastName,
    required this.description,
  });

  final String ibanNumber;
  final double amount;
  final String firstName;
  final String lastName;
  final String description;
}
