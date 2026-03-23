import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/merchant_wallet.dart';
import 'package:payinall/domain/repositories/wallets_repository.dart';

final class GetMerchantWalletUsecase
    implements BaseUsecaseWithoutParams<MerchantWallet> {
  GetMerchantWalletUsecase(this.repository);

  final WalletsRepository repository;

  @override
  Future<Either<Failure, MerchantWallet>> call() async {
    final result = await repository.getMerchantWallet();
    return result;
  }
}
