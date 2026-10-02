import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/card_bin.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetCardBinCodeUsecase
    implements BaseUsecase<List<CardBin>, String> {
  GetCardBinCodeUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, List<CardBin>>> call(String countryCode) async {
    return repository.getCardBinCode(countryCode);
  }
}
