import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/request_moneys_params.dart';
import 'package:payinall/domain/repositories/request_moneys_repository.dart';

final class RequestMoneyUsecase
    implements BaseUsecase<void, RequestMoneyParams> {
  RequestMoneyUsecase(this.repository);

  final RequestMoneysRepository repository;

  @override
  Future<Either<Failure, void>> call(RequestMoneyParams params) async {
    final result = await repository.requestMoney(params);
    return result;
  }
}
