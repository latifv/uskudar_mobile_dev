import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/contract_response.dart';
import 'package:uskudar_mobile/domain/entities/contract.dart';

final class ContractModel extends Contract {
  const ContractModel({
    required super.id,
    required super.code,
    required super.name,
    required super.content,
  });
  factory ContractModel.fromResponse(ContractResponse response) {
    if (response.id == null ||
        response.code == null ||
        response.name == null ||
        response.content == null) {
      throw const MappingException();
    }

    return ContractModel(
      id: response.id!,
      code: response.code!,
      name: response.name!,
      content: response.content!,
    );
  }
}
