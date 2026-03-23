import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/customer_banks_params.dart';
import 'package:payinall/domain/repositories/customer_banks_repository.dart';

final class CustomerMerchantBankUsecase
    implements BaseUsecase<void, CustomerBanksParams> {
  CustomerMerchantBankUsecase(this.repository);

  final CustomerBanksRepository repository;

  @override
  Future<Either<Failure, void>> call(CustomerBanksParams params) async {
    final result = await repository.addMerchantBank(params);
    return result;
  }
}
