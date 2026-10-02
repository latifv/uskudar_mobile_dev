import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

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
