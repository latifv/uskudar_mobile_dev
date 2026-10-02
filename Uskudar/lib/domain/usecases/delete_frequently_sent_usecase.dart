import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/frequently_sents_repository.dart';

final class DeleteFrequentlySentUsecase implements BaseUsecase<String, int> {
  DeleteFrequentlySentUsecase(this.repository);

  final FrequentlySentsRepository repository;

  @override
  Future<Either<Failure, String>> call(int id) async {
    final result = await repository.deleteFrequentlySent(id);
    return result;
  }
}
