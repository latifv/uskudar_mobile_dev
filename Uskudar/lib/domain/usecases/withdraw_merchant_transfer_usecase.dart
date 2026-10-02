import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/domain/params/merchant_withdraw_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';

final class WithdrawMerchantTransferUsecase
    implements BaseUsecase<WithdrawTransfer, MerchantWithdrawTransferParams> {
  WithdrawMerchantTransferUsecase(this.repository);

  final TransfersRepository repository;

  @override
  Future<Either<Failure, WithdrawTransfer>> call(
    MerchantWithdrawTransferParams params,
  ) async {
    final result = await repository.withdrawMerchantTransfer(params);
    return result;
  }
}
