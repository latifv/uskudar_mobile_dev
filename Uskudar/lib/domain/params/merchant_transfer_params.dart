class MerchantTransferParams {
  const MerchantTransferParams({
    required this.customerNumber,
    required this.amount,
  });

  final String customerNumber;
  final double amount;
}
