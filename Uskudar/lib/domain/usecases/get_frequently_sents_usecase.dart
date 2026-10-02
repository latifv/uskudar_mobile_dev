import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/frequently_sent.dart';
import 'package:uskudar_mobile/domain/repositories/frequently_sents_repository.dart';

final class GetFrequentlySentsUsecase
    implements BaseUsecaseWithoutParams<List<FrequentlySent>> {
  GetFrequentlySentsUsecase(this.repository);

  final FrequentlySentsRepository repository;

  @override
  Future<Either<Failure, List<FrequentlySent>>> call() async {
    final result = await repository.getFrequentlySents();
    return result;
  }
}
