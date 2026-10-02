import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/frequent_iban_response.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';

final class FrequentIbanModel extends FrequentIban {
  const FrequentIbanModel({
    required super.id,
    required super.ibanNo,
    required super.firstName,
    required super.lastName,
    required super.createdDate,
  });

  factory FrequentIbanModel.fromResponse(FrequentIbanResponse response) {
    if (response.id == null ||
        response.ibanNo == null ||
        response.firstName == null ||
        response.lastName == null ||
        response.createdDate == null) {
      throw const MappingException();
    }

    return FrequentIbanModel(
      id: response.id!,
      ibanNo: response.ibanNo!,
      firstName: response.firstName!,
      lastName: response.lastName!,
      createdDate: response.createdDate!,
    );
  }
}
