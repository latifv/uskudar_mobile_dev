class PointOfSaleLocation {
  const PointOfSaleLocation({
    required this.id,
    required this.lat,
    required this.lng,
    required this.city,
    required this.district,
    required this.saleAddress,
    required this.sector,
    required this.subSector,
    required this.telNo,
    required this.signboardName,
  });

  final String id;
  final String lat;
  final String lng;
  final String city;
  final String district;
  final String saleAddress;
  final String sector;
  final String subSector;
  final String telNo;
  final String signboardName;
}
