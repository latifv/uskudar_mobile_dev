import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/merchant_wallet_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/wallet_response.dart';
import 'package:uskudar_mobile/data/models/merchant_wallet_model.dart';
import 'package:uskudar_mobile/data/models/wallet_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class WalletsRemoteDataSource {
  Future<NetworkResponse<WalletModel>> getWallet();
  Future<NetworkResponse<MerchantWalletModel>> getMerchantWallet();
}

final class WalletsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements WalletsRemoteDataSource {
  WalletsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<WalletModel>> getWallet() async {
    final responseJson = await get(endpoint: Endpoints.wallet);

    final response = NetworkResponse.fromJson<WalletResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return WalletResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(WalletModel.fromResponse);
  }

  @override
  Future<NetworkResponse<MerchantWalletModel>> getMerchantWallet() async {
    final responseJson = await get(endpoint: Endpoints.merchantWallet);

    final response = NetworkResponse.fromJson<MerchantWalletResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return MerchantWalletResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(MerchantWalletModel.fromResponse);
  }
}
