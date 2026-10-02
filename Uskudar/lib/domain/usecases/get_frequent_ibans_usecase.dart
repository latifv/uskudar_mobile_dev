import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/frequent_iban.dart';
import 'package:uskudar_mobile/domain/repositories/frequent_ibans_repository.dart';

final class GetFrequentIbansUsecase
    implements BaseUsecaseWithoutParams<List<FrequentIban>> {
  GetFrequentIbansUsecase(this.repository);

  final FrequentIbansRepository repository;

  @override
  Future<Either<Failure, List<FrequentIban>>> call() async {
    final result = await repository.getFrequentIbans();
    return result;
  }
}
