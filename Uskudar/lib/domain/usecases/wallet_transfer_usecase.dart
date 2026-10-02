import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/params/wallet_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';

final class WalletTransferUsecase
    implements BaseUsecase<WalletTransfer, WalletTransferParams> {
  WalletTransferUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, WalletTransfer>> call(
    WalletTransferParams params,
  ) async {
    final result = await repository.walletTransfer(params);
    return result;
  }
}
