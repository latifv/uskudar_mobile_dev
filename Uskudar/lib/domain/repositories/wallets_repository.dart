import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/merchant_wallet.dart';
import 'package:uskudar_mobile/domain/entities/wallet.dart';

abstract interface class WalletsRepository {
  Future<Either<Failure, Wallet>> getWallet();
  Future<Either<Failure, MerchantWallet>> getMerchantWallet();
}
