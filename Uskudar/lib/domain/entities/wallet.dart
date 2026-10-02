class Wallet {
  const Wallet({
    required this.balance,
    required this.availableBalance,
    required this.blockBalance,
  });

  final double balance;
  final double availableBalance;
  final double blockBalance;
}
