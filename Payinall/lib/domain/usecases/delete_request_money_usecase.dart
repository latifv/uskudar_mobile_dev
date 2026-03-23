import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/request_moneys_repository.dart';

final class DeleteRequestMoneyUsecase implements BaseUsecase<void, int> {
  DeleteRequestMoneyUsecase(this.repository);

  final RequestMoneysRepository repository;

  @override
  Future<Either<Failure, void>> call(int id) async {
    final result = await repository.deleteRequestMoney(id);
    return result;
  }
}
