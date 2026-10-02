class CustomerCoupon {
  const CustomerCoupon({
    required this.id,
    required this.fullName,
    required this.customerNumber,
    required this.customerId,
    required this.code,
    required this.pin,
    required this.merchantName,
    required this.logo,
    required this.purchaseDate,
    required this.amount,
    required this.cashbackAmount,
    required this.isDeleted,
  });

  final int id;
  final String fullName;
  final String customerNumber;
  final int customerId;
  final String code;
  final String pin;
  final String merchantName;
  final String logo;
  final DateTime purchaseDate;
  final double amount;
  final double cashbackAmount;
  final bool isDeleted;
}
