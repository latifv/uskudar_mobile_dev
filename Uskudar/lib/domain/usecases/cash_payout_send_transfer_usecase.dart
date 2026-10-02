import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';
import 'package:payinall/domain/params/cash_payout_send_transfer_params.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class CashPayoutSendTransferUsecase
    implements
        BaseUsecase<InternationalTransferResult, CashPayoutSendTransferParams> {
  CashPayoutSendTransferUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, InternationalTransferResult>> call(
    CashPayoutSendTransferParams params,
  ) async {
    final result = await repository.cashPayoutSendTransfer(params);
    return result;
  }
}
