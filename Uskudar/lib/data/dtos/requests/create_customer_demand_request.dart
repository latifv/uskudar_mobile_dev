import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/create_customer_demand_params.dart';

part 'create_customer_demand_request.g.dart';

@JsonSerializable(createFactory: false)
final class CreateCustomerDemandRequest extends CreateCustomerDemandParams {
  const CreateCustomerDemandRequest({
    required super.requestSubjectId,
    required super.title,
    required super.content,
  });

  factory CreateCustomerDemandRequest.fromParams(
    CreateCustomerDemandParams params,
  ) {
    return CreateCustomerDemandRequest(
      requestSubjectId: params.requestSubjectId,
      title: params.title,
      content: params.content,
    );
  }

  Map<String, dynamic> toJson() => _$CreateCustomerDemandRequestToJson(this);
}
