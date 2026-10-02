import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/repositories/app_repository.dart';

final class GetIsFirstRunUsecase implements BaseUsecaseWithoutParams<bool> {
  GetIsFirstRunUsecase(this.repository);

  final AppRepository repository;

  @override
  Future<Either<Failure, bool>> call() async {
    final result = await repository.getIsFirstRun();
    return result;
  }
}
