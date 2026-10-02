import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/signalr_manager.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class RemoveUsecase implements BaseUsecaseWithoutParams<String> {
  RemoveUsecase(this.repository, this.signalRManager);

  final UsersRepository repository;
  final SignalRManager signalRManager;

  @override
  Future<Either<Failure, String>> call() async {
    await signalRManager.disconnect();

    final result = await repository.remove();
    return result;
  }
}
