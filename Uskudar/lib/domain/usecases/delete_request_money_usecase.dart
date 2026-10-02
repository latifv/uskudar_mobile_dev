import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/request_moneys_repository.dart';

final class DeleteRequestMoneyUsecase implements BaseUsecase<void, int> {
  DeleteRequestMoneyUsecase(this.repository);

  final RequestMoneysRepository repository;

  @override
  Future<Either<Failure, void>> call(int id) async {
    final result = await repository.deleteRequestMoney(id);
    return result;
  }
}
