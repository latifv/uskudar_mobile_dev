import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/commission.dart';
import 'package:uskudar_mobile/domain/repositories/commissions_repository.dart';

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
