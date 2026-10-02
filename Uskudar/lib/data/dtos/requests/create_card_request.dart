import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/create_card_params.dart';

part 'create_card_request.g.dart';

@JsonSerializable(createFactory: false)
final class CreateCardRequest extends CreateCardParams {
  const CreateCardRequest({
    required super.individualFrameworkAgreement,
    required super.preliminaryInformationAgreement,
    required super.commercialElectronicCommunicationAgreement,
    required super.kvkkAgreement,
  });

  factory CreateCardRequest.fromParams(CreateCardParams params) {
    return CreateCardRequest(
      individualFrameworkAgreement: params.individualFrameworkAgreement,
      preliminaryInformationAgreement: params.preliminaryInformationAgreement,
      commercialElectronicCommunicationAgreement:
          params.commercialElectronicCommunicationAgreement,
      kvkkAgreement: params.kvkkAgreement,
    );
  }

  Map<String, dynamic> toJson() => _$CreateCardRequestToJson(this);
}
