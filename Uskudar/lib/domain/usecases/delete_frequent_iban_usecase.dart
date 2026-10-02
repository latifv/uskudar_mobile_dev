import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/frequent_ibans_repository.dart';

final class DeleteFrequentIbanUsecase implements BaseUsecase<String, String> {
  DeleteFrequentIbanUsecase(this.repository);

  final FrequentIbansRepository repository;

  @override
  Future<Either<Failure, String>> call(String id) async {
    final result = await repository.deleteFrequentIban(id);
    return result;
  }
}
