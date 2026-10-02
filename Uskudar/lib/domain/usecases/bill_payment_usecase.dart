import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/bill_payment_params.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';

final class BillPaymentUsecase implements BaseUsecase<void, BillPaymentParams> {
  BillPaymentUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, void>> call(BillPaymentParams params) async {
    final result = await repository.billPayment(params);
    return result;
  }
}
