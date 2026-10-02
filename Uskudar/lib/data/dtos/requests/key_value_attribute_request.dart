import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/key_value_attribute.dart';

part 'key_value_attribute_request.g.dart';

@JsonSerializable()
final class KeyValueAttributeRequest extends KeyValueAttribute {
  const KeyValueAttributeRequest({
    required super.key,
    required super.value,
  });

  factory KeyValueAttributeRequest.fromJson(Map<String, dynamic> json) =>
      _$KeyValueAttributeRequestFromJson(json);

  factory KeyValueAttributeRequest.fromDomain(KeyValueAttribute attribute) {
    return KeyValueAttributeRequest(
      key: attribute.key,
      value: attribute.value,
    );
  }

  Map<String, dynamic> toJson() => _$KeyValueAttributeRequestToJson(this);
}
