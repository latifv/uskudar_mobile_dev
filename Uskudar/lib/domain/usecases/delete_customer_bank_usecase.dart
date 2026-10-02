import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/customer_banks_repository.dart';

final class DeleteCustomerBankUsecase implements BaseUsecase<void, String> {
  DeleteCustomerBankUsecase(this.repository);

  final CustomerBanksRepository repository;

  @override
  Future<Either<Failure, void>> call(String ibanNumber) async {
    final result = await repository.deleteBank(ibanNumber);
    return result;
  }
}
