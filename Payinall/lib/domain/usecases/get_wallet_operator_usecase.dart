import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/wallet_operator.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

class GetWalletOperatorUsecase {
  GetWalletOperatorUsecase(this._repository);

  final InternationalMoneyTransferRepository _repository;

  Future<Either<Failure, List<WalletOperator>>> call(String countryCode) {
    return _repository.getWalletOperator(countryCode);
  }
}
