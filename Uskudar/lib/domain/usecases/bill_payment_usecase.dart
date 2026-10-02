import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/bill_payment_params.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

final class BillPaymentUsecase implements BaseUsecase<void, BillPaymentParams> {
  BillPaymentUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, void>> call(BillPaymentParams params) async {
    final result = await repository.billPayment(params);
    return result;
  }
}
