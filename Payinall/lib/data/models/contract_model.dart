import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/contract_response.dart';
import 'package:payinall/domain/entities/contract.dart';

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
