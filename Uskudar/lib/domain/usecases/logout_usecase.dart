import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/signalr_manager.dart';
import 'package:payinall/core/managers/token_manager.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/repositories/customers_repository.dart';

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
