import 'package:json_annotation/json_annotation.dart';

part 'constants_data_response.g.dart';

@JsonSerializable(createToJson: false)
final class ConstantsDataResponse {
  const ConstantsDataResponse({this.key, this.value});

  factory ConstantsDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ConstantsDataResponseFromJson(json);

  final int? key;
  final String? value;
}
