import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/domain/params/point_of_sale_location_filter_params.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

final class GetPointOfSaleLocationFilterListUsecase
    implements
        BaseUsecase<List<PointOfSaleLocation>,
            PointOfSaleLocationFilterParams> {
  GetPointOfSaleLocationFilterListUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, List<PointOfSaleLocation>>> call(
    PointOfSaleLocationFilterParams params,
  ) async {
    return repository.pointOfSaleLocationFilterList(params);
  }
}
