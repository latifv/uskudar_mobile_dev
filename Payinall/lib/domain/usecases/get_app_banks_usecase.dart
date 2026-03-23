import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/app_bank.dart';
import 'package:payinall/domain/repositories/app_banks_repository.dart';

final class GetAppBanksUsecase
    implements BaseUsecaseWithoutParams<List<AppBank>> {
  GetAppBanksUsecase(this.repository);

  final AppBanksRepository repository;

  @override
  Future<Either<Failure, List<AppBank>>> call() async {
    final result = await repository.getActives();
    return result;
  }
}
