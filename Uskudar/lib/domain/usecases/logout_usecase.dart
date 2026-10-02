import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/signalr_manager.dart';
import 'package:uskudar_mobile/core/managers/token_manager.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/repositories/customers_repository.dart';

final class LogoutUsecase implements BaseUsecaseWithoutParams<void> {
  LogoutUsecase(this.repository, this.signalRManager, this.tokenManager);

  final CustomersRepository repository;
  final SignalRManager signalRManager;
  final TokenManager tokenManager;

  @override
  Future<Either<Failure, void>> call() async {
    await signalRManager.disconnect();
    tokenManager.clearToken();
    final result = await repository.logOut();
    return result;
  }
}
