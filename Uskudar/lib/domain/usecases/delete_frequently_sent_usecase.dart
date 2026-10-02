import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/frequently_sents_repository.dart';

final class DeleteFrequentlySentUsecase implements BaseUsecase<String, int> {
  DeleteFrequentlySentUsecase(this.repository);

  final FrequentlySentsRepository repository;

  @override
  Future<Either<Failure, String>> call(int id) async {
    final result = await repository.deleteFrequentlySent(id);
    return result;
  }
}
