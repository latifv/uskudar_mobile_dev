import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/address_number_inquiry_request.dart';
import 'package:payinall/data/dtos/requests/user_address_information_approve_request.dart';
import 'package:payinall/data/dtos/responses/user_address_information_response.dart';
import 'package:payinall/data/models/user_address_information_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class UserAddressInformationsRemoteDataSource {
  Future<NetworkResponse<void>> addressNumberInquiry(
    AddressNumberInquiryRequest request,
  );

  Future<NetworkResponse<UserAddressInformationModel>>
  getUserAddressInformation();

  Future<NetworkResponse<void>> userAddressInformationApprove(
    UserAddressInformationApproveRequest request,
  );
}

final class UserAddressInformationsRemoteDataSourceImpl
    extends BaseRemoteDataSource
    implements UserAddressInformationsRemoteDataSource {
  UserAddressInformationsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> addressNumberInquiry(
    AddressNumberInquiryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.addressNumberInquiry,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<UserAddressInformationModel>>
  getUserAddressInformation() async {
    final responseJson = await get(
      endpoint: Endpoints.getUserAddressInformation,
    );

    final response = NetworkResponse.fromJson<UserAddressInformationResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return UserAddressInformationResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(UserAddressInformationModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> userAddressInformationApprove(
    UserAddressInformationApproveRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.userAddressInformationApprove,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
