import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/customer_mobiles_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_mobiles_repository.dart';

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
