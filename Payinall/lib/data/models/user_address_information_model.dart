import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/user_address_information_response.dart';
import 'package:payinall/domain/entities/user_address_information.dart';

final class UserAddressInformationModel extends UserAddressInformation {
  const UserAddressInformationModel({
    required super.address,
    required super.addressNumber,
  });

  factory UserAddressInformationModel.fromResponse(
    UserAddressInformationResponse response,
  ) {
    if (response.address == null || response.addressNumber == null) {
      throw const MappingException();
    }
    return UserAddressInformationModel(
      address: response.address!,
      addressNumber: response.addressNumber!,
    );
  }
}
