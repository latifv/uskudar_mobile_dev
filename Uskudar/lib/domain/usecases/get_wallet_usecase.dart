import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/wallet.dart';
import 'package:uskudar_mobile/domain/repositories/wallets_repository.dart';

final class GetWalletUsecase implements BaseUsecaseWithoutParams<Wallet> {
  GetWalletUsecase(this.repository);

  final WalletsRepository repository;

  @override
  Future<Either<Failure, Wallet>> call() async {
    final result = await repository.getWallet();
    return result;
  }
}
