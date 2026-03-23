import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/wallet_transfer.dart';
import 'package:payinall/domain/params/wallet_transfer_params.dart';
import 'package:payinall/domain/repositories/transfers_repository.dart';

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
