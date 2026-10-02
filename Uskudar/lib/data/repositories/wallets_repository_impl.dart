import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/wallets_remote_data_source.dart';
import 'package:payinall/data/models/merchant_wallet_model.dart';
import 'package:payinall/data/models/wallet_model.dart';
import 'package:payinall/domain/entities/merchant_wallet.dart';
import 'package:payinall/domain/entities/wallet.dart';
import 'package:payinall/domain/repositories/wallets_repository.dart';

final class WalletsRepositoryImpl implements WalletsRepository {
  WalletsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final WalletsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    return _dataSourceHandler.handle<Wallet, WalletModel>(
      remoteFunction: () async {
        final result = await remoteDataSource.getWallet();
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, MerchantWallet>> getMerchantWallet() async {
    return _dataSourceHandler.handle<MerchantWallet, MerchantWalletModel>(
      remoteFunction: () async {
        final result = await remoteDataSource.getMerchantWallet();
        return result;
      },
      onlyData: true,
    );
  }
}
