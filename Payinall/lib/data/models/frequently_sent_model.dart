import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/frequently_sent_response.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';

final class FrequentlySentModel extends FrequentlySent {
  const FrequentlySentModel({
    required super.id,
    required super.customerNumber,
    required super.fullName,
  });

  factory FrequentlySentModel.fromResponse(FrequentlySentResponse response) {
    if (response.id == null ||
        response.customerNumber == null ||
        response.fullName == null) {
      throw const MappingException();
    }

    return FrequentlySentModel(
      id: response.id!,
      customerNumber: response.customerNumber!,
      fullName: response.fullName!,
    );
  }
}
