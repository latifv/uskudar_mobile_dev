import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/merchant_wallet.dart';
import 'package:payinall/domain/entities/wallet.dart';

abstract interface class WalletsRepository {
  Future<Either<Failure, Wallet>> getWallet();
  Future<Either<Failure, MerchantWallet>> getMerchantWallet();
}
