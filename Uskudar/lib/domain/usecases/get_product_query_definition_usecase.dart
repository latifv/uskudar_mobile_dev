import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_query_definition.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

final class GetProductQueryDefinitionUsecase
    implements BaseUsecase<List<BillProductQueryDefinition>, String> {
  GetProductQueryDefinitionUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, List<BillProductQueryDefinition>>> call(
    String productId,
  ) async {
    final result = await repository.productQueryDefinition(productId);
    return result;
  }
}
