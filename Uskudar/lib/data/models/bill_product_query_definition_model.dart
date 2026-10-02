import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/bill_product_query_definition_response.dart';
import 'package:payinall/domain/entities/bill_product_query_definition.dart';

final class BillProductQueryDefinitionModel extends BillProductQueryDefinition {
  const BillProductQueryDefinitionModel({
    required super.subcriberNumberLabel,
    required super.subcriberNumberKeySizeOrder,
    required super.mandatoryParams,
  });

  factory BillProductQueryDefinitionModel.fromResponse(
    BillProductQueryDefinitionResponse response,
  ) {
    if (response.subcriberNumberLabel == null ||
        response.subcriberNumberKeySizeOrder == null ||
        response.mandatoryParams == null) {
      throw const MappingException();
    }

    return BillProductQueryDefinitionModel(
      subcriberNumberLabel: response.subcriberNumberLabel!,
      subcriberNumberKeySizeOrder: response.subcriberNumberKeySizeOrder!,
      mandatoryParams: response.mandatoryParams!,
    );
  }
}
