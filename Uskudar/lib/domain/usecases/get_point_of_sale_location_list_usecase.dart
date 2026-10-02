import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/point_of_sale_location.dart';
import 'package:uskudar_mobile/domain/params/point_of_sale_location_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class GetPointOfSaleLocationListUsecase
    implements
        BaseUsecase<List<PointOfSaleLocation>, PointOfSaleLocationParams> {
  GetPointOfSaleLocationListUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, List<PointOfSaleLocation>>> call(
    PointOfSaleLocationParams params,
  ) async {
    return repository.pointOfSaleLocationList(params);
  }
}
