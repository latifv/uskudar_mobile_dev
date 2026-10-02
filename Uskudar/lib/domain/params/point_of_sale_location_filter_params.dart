class PointOfSaleLocationFilterParams {
  const PointOfSaleLocationFilterParams({
    required this.name,
    required this.city,
    required this.county,
    required this.metropolTypes,
  });

  final String name;
  final String city;
  final String county;
  final int metropolTypes;
}
