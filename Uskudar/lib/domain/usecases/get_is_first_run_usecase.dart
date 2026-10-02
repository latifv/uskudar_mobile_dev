import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/repositories/app_repository.dart';

final class GetIsFirstRunUsecase implements BaseUsecaseWithoutParams<bool> {
  GetIsFirstRunUsecase(this.repository);

  final AppRepository repository;

  @override
  Future<Either<Failure, bool>> call() async {
    final result = await repository.getIsFirstRun();
    return result;
  }
}
