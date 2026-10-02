import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_card_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/campaign_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/iwallet_agreement_response.dart';
import 'package:uskudar_mobile/data/models/campaign_model.dart';
import 'package:uskudar_mobile/data/models/iwallet_agreement_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CampaignsRemoteDataSource {
  Future<NetworkResponse<List<CampaignModel>>> getCampaigns();
  Future<NetworkResponse<String>> createQrCode();
  Future<NetworkResponse<void>> createCard(CreateCardRequest request);
  Future<NetworkResponse<List<IWalletAgreementModel>>> getIWalletAgreements();
}

final class CampaignsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CampaignsRemoteDataSource {
  CampaignsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<CampaignModel>>> getCampaigns() async {
    final responseJson = await get(endpoint: Endpoints.campaigns);

    final response = NetworkResponse.fromJson<List<CampaignResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    CampaignResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) => responseList.map(CampaignModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<String>> createQrCode() async {
    final responseJson = await get(
      endpoint: Endpoints.createQrCode,
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> createCard(CreateCardRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.createCard,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<List<IWalletAgreementModel>>>
  getIWalletAgreements() async {
    final responseJson = await get(endpoint: Endpoints.iwalletAgreements);

    final response = NetworkResponse.fromJson<List<IWalletAgreementResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => IWalletAgreementResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) =>
          responseList.map(IWalletAgreementModel.fromResponse).toList(),
    );

    return result;
  }
}
