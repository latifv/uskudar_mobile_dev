import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/bic_bank.dart';
import 'package:payinall/domain/params/get_bic_bank_list_params.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetBicBankListUsecase
    implements BaseUsecase<List<BicBank>, GetBicBankListParams> {
  GetBicBankListUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, List<BicBank>>> call(
    GetBicBankListParams params,
  ) async {
    return repository.getBicBankList(params);
  }
}
