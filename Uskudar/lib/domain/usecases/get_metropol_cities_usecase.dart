import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/metropol_city.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class GetMetropolCitiesUsecase
    implements BaseUsecaseWithoutParams<List<MetropolCity>> {
  GetMetropolCitiesUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, List<MetropolCity>>> call() async {
    return repository.getCities();
  }
}
