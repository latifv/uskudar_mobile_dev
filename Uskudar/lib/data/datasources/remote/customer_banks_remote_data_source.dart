import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/customer_banks_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_bank_response.dart';
import 'package:uskudar_mobile/data/models/customer_bank_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CustomerBanksRemoteDataSource {
  Future<NetworkResponse<List<CustomerBankModel>>> getBanks();
  Future<NetworkResponse<void>> addBank(CustomerBanksRequest request);
  Future<NetworkResponse<void>> addMerchantBank(CustomerBanksRequest request);
  Future<NetworkResponse<void>> deleteBank(String ibanNumber);
}

final class CustomerBanksRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CustomerBanksRemoteDataSource {
  CustomerBanksRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<CustomerBankModel>>> getBanks() async {
    final responseJson = await get(endpoint: Endpoints.customerBanks);
    final response = NetworkResponse.fromJson<List<CustomerBankResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    CustomerBankResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(CustomerBankModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<void>> addBank(CustomerBanksRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.customerBanks,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> addMerchantBank(
    CustomerBanksRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.customerBanksAddMerchant,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> deleteBank(String ibanNumber) async {
    final responseJson = await delete(
      endpoint: Endpoints.deleteBank(ibanNumber),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
