import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/constants_data.dart';
import 'package:uskudar_mobile/domain/repositories/constants_data_list_repository.dart';

final class GetMonthlyTransactionCountTypesUsecase
    implements BaseUsecaseWithoutParams<List<ConstantsData>> {
  GetMonthlyTransactionCountTypesUsecase(this.repository);

  final ConstantsDataListRepository repository;

  @override
  Future<Either<Failure, List<ConstantsData>>> call() async {
    final result = await repository.getMonthlyTransactionCountTypes();
    return result;
  }
}
