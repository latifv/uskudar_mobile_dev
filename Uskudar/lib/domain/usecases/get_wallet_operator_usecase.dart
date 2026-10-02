import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/wallet_operator.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';

class GetWalletOperatorUsecase {
  GetWalletOperatorUsecase(this._repository);

  final InternationalMoneyTransferRepository _repository;

  Future<Either<Failure, List<WalletOperator>>> call(String countryCode) {
    return _repository.getWalletOperator(countryCode);
  }
}
