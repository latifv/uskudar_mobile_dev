import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/frequently_sents_repository.dart';

final class AddFrequentlySentUsecase implements BaseUsecase<String, String> {
  AddFrequentlySentUsecase(this.repository);

  final FrequentlySentsRepository repository;

  @override
  Future<Either<Failure, String>> call(String customerNumber) async {
    final result = await repository.addFrequentlySent(customerNumber);
    return result;
  }
}
