import 'package:json_annotation/json_annotation.dart';

part 'customer_demand_subject_response.g.dart';

@JsonSerializable(createToJson: false)
final class CustomerDemandSubjectResponse {
  const CustomerDemandSubjectResponse({this.key, this.value});

  factory CustomerDemandSubjectResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerDemandSubjectResponseFromJson(json);

  final int? key;
  final String? value;
}
