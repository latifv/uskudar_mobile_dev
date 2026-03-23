import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/metropol_user_detail.dart';
import 'package:payinall/domain/repositories/metropols_repository.dart';

final class CreateMetropolUserOrDetailUsecase
    implements BaseUsecaseWithoutParams<MetropolUserDetail> {
  CreateMetropolUserOrDetailUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, MetropolUserDetail>> call() async {
    return repository.createUserOrDetail();
  }
}
