import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_type.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

final class GetProductTypesUsecase
    implements BaseUsecase<List<BillProductType>, void> {
  GetProductTypesUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, List<BillProductType>>> call(void params) async {
    final result = await repository.getProductTypes();
    return result;
  }
}
