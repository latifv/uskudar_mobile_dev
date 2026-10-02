import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/back_image_check_request.dart';
import 'package:payinall/data/dtos/requests/face_image_check_request.dart';
import 'package:payinall/data/dtos/requests/front_image_check_request.dart';
import 'package:payinall/data/dtos/requests/nfc_check_request.dart';
import 'package:payinall/data/dtos/responses/nfc_response.dart';
import 'package:payinall/data/models/nfc_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class ArkSignersRemoteDataSource {
  Future<NetworkResponse<String>> frontImageCheck(
    FrontImageCheckRequest request,
  );
  Future<NetworkResponse<void>> backImageCheck(BackImageCheckRequest request);
  Future<NetworkResponse<NfcModel>> nfcCheck(NfcCheckRequest request);
  Future<NetworkResponse<void>> faceImageCheck(FaceImageCheckRequest request);
}

final class ArkSignersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ArkSignersRemoteDataSource {
  ArkSignersRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<String>> frontImageCheck(
    FrontImageCheckRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.frontImageCheck,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> backImageCheck(
    BackImageCheckRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.backImageCheck,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<NfcModel>> nfcCheck(NfcCheckRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.nfcCheck,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<NfcResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return NfcResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(NfcModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> faceImageCheck(
    FaceImageCheckRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.faceImageCheck,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
