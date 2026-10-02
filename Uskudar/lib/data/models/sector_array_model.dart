import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/sector_array_response.dart';
import 'package:payinall/domain/entities/sector_array.dart';

final class SectorArrayModel extends SectorArray {
  const SectorArrayModel({
    required super.id,
    required super.letter,
    required super.name,
  });

  factory SectorArrayModel.fromResponse(SectorArrayResponse response) {
    if (response.id == null ||
        response.letter == null ||
        response.name == null) {
      throw const MappingException();
    }

    return SectorArrayModel(
      id: response.id!,
      letter: response.letter!,
      name: response.name!,
    );
  }
}
