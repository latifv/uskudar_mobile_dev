import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/commission.dart';
import 'package:payinall/domain/repositories/commissions_repository.dart';

final class GetCommissionsActiveListUsecase
    implements BaseUsecaseWithoutParams<List<Commission>> {
  GetCommissionsActiveListUsecase(this.repository);

  final CommissionsRepository repository;

  @override
  Future<Either<Failure, List<Commission>>> call() async {
    final result = await repository.getActiveList();
    return result;
  }
}
