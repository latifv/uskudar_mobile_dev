import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/responses/avatar_image_response.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class AvatarImagesRemoteDataSource {
  Future<NetworkResponse<List<AvatarImageResponse>>> getAvatarImages();
  Future<NetworkResponse<void>> selectCustomerAvatar(int avatarId);
  Future<NetworkResponse<void>> deleteCustomerAvatar();
}

final class AvatarImagesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AvatarImagesRemoteDataSource {
  AvatarImagesRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<AvatarImageResponse>>> getAvatarImages() async {
    final responseJson = await get(endpoint: Endpoints.avatarImages);

    final response = NetworkResponse.fromJson<List<AvatarImageResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (e) => AvatarImageResponse.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> selectCustomerAvatar(int avatarId) async {
    final responseJson = await post(
      endpoint: Endpoints.selectCustomerAvatar(avatarId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> deleteCustomerAvatar() async {
    final responseJson = await delete(
      endpoint: Endpoints.deleteCustomerAvatar,
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
