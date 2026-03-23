import 'package:json_annotation/json_annotation.dart';

part 'nfc_response.g.dart';

@JsonSerializable(createToJson: false)
final class NfcResponse {
  const NfcResponse({
    this.image,
  });

  factory NfcResponse.fromJson(Map<String, dynamic> json) =>
      _$NfcResponseFromJson(json);

  final String? image;
}
