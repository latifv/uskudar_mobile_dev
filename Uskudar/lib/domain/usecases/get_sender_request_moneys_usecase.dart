import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/request_money.dart';
import 'package:uskudar_mobile/domain/repositories/request_moneys_repository.dart';

final class GetSenderRequestMoneysUsecase
    implements BaseUsecaseWithoutParams<List<RequestMoney>> {
  GetSenderRequestMoneysUsecase(this.repository);

  final RequestMoneysRepository repository;

  @override
  Future<Either<Failure, List<RequestMoney>>> call() async {
    final result = await repository.getSenderRequestMoneys();
    return result;
  }
}
