import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/params/merchant_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';

final class MerchantTransferUsecase
    implements BaseUsecase<WalletTransfer, MerchantTransferParams> {
  MerchantTransferUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, WalletTransfer>> call(
    MerchantTransferParams params,
  ) async {
    final result = await repository.merchantTransfer(params);
    return result;
  }
}
