import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/constants_data_response.dart';
import 'package:payinall/domain/entities/constants_data.dart';

final class ConstantsDataModel extends ConstantsData {
  const ConstantsDataModel({required super.key, required super.value});

  factory ConstantsDataModel.fromResponse(ConstantsDataResponse response) {
    if (response.key == null || response.value == null) {
      throw const MappingException();
    }

    return ConstantsDataModel(key: response.key!, value: response.value!);
  }
}
