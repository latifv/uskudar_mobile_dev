import 'package:uskudar_mobile/domain/entities/sector_array.dart';

class Merchant {
  const Merchant({
    required this.id,
    required this.name,
    required this.type,
    required this.sectorArr,
    required this.logo,
    required this.sectorArray,
  });

  final int id;
  final String name;
  final String type;
  final List<String> sectorArr;
  final String logo;
  final List<SectorArray> sectorArray;
}
