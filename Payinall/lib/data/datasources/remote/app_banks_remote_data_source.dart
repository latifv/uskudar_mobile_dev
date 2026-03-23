import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/responses/app_bank_response.dart';
import 'package:payinall/data/models/app_bank_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class AppBanksRemoteDataSource {
  Future<NetworkResponse<List<AppBankModel>>> getActives();
}

final class AppBanksRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AppBanksRemoteDataSource {
  AppBanksRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<AppBankModel>>> getActives() async {
    final responseJson = await get(endpoint: Endpoints.appBanksGetActives);
    final response = NetworkResponse.fromJson<List<AppBankResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    AppBankResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) => responseList.map(AppBankModel.fromResponse).toList(),
    );
  }
}
