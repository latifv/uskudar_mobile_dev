import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/help.dart';
import 'package:payinall/domain/repositories/helps_repository.dart';

final class GetHelpsUsecase implements BaseUsecaseWithoutParams<List<Help>> {
  GetHelpsUsecase(this.repository);

  final HelpsRepository repository;

  @override
  Future<Either<Failure, List<Help>>> call() async {
    final result = await repository.getHelps();
    return result;
  }
}
