import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';

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
