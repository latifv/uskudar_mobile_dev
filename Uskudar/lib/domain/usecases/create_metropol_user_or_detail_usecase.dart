import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_detail.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class CreateMetropolUserOrDetailUsecase
    implements BaseUsecaseWithoutParams<MetropolUserDetail> {
  CreateMetropolUserOrDetailUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, MetropolUserDetail>> call() async {
    return repository.createUserOrDetail();
  }
}
