import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/bic_bank.dart';
import 'package:uskudar_mobile/domain/params/get_bic_bank_list_params.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';

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
