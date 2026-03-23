import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

final class GetMetropolCitiesUsecase
    implements BaseUsecaseWithoutParams<List<MetropolCity>> {
  GetMetropolCitiesUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, List<MetropolCity>>> call() async {
    return repository.getCities();
  }
}
