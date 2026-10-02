import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/merchant_wallet.dart';
import 'package:uskudar_mobile/domain/repositories/wallets_repository.dart';

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
