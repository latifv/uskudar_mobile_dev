class GiftCheckBrandDetail {
  const GiftCheckBrandDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.banner,
    required this.cashbackRate,
    required this.kdvRate,
  });

  final String id;
  final String name;
  final String description;
  final String logo;
  final String banner;
  final double cashbackRate;
  final double kdvRate;
}
