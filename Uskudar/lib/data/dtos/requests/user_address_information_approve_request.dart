import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/user_address_information_approve_params.dart';

part 'user_address_information_approve_request.g.dart';

@JsonSerializable(createFactory: false)
final class UserAddressInformationApproveRequest
    extends UserAddressInformationApproveParams {
  const UserAddressInformationApproveRequest({
    required super.isManuel,
    super.address,
  });

  factory UserAddressInformationApproveRequest.fromParams(
    UserAddressInformationApproveParams params,
  ) {
    return UserAddressInformationApproveRequest(
      isManuel: params.isManuel,
      address: params.address,
    );
  }

  Map<String, dynamic> toJson() =>
      _$UserAddressInformationApproveRequestToJson(this);
}
