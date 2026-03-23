import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class ConfirmInternationalTransferUsecase
    implements BaseUsecase<String, String> {
  ConfirmInternationalTransferUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, String>> call(String transactionId) async {
    final result = await repository.confirmTransfer(transactionId);
    return result;
  }
}
