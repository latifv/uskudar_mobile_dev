import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/customer_mobiles_params.dart';
import 'package:payinall/domain/repositories/customer_mobiles_repository.dart';

final class CustomerMobilesUsecase
    implements BaseUsecase<void, CustomerMobilesParams> {
  CustomerMobilesUsecase(this.repository);

  final CustomerMobilesRepository repository;

  @override
  Future<Either<Failure, void>> call(CustomerMobilesParams params) async {
    final result = await repository.customerMobiles(params);
    return result;
  }
}
