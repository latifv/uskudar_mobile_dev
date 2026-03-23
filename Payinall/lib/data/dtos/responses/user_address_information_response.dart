import 'package:json_annotation/json_annotation.dart';

part 'user_address_information_response.g.dart';

@JsonSerializable(createToJson: false)
final class UserAddressInformationResponse {
  const UserAddressInformationResponse({this.address, this.addressNumber});

  factory UserAddressInformationResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAddressInformationResponseFromJson(json);

  final String? address;
  final String? addressNumber;
}
