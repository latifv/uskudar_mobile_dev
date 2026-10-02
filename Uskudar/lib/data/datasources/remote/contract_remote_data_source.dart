import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/responses/contract_response.dart';
import 'package:payinall/data/models/contract_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class ContractsRemoteDataSource {
  Future<NetworkResponse<List<ContractModel>>> getContracts();
  Future<NetworkResponse<ContractModel>> getContractByContractCode(
    String contractCode,
  );
}

final class ContractsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ContractsRemoteDataSource {
  ContractsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<ContractModel>>> getContracts() async {
    final responseJson = await get(endpoint: Endpoints.contracts);

    final response = NetworkResponse.fromJson<List<ContractResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    ContractResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) => responseList.map(ContractModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<ContractModel>> getContractByContractCode(
    String contractCode,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getContractByContractCode(contractCode),
    );

    final response = NetworkResponse.fromJson<ContractResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return ContractResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(ContractModel.fromResponse);
  }
}
