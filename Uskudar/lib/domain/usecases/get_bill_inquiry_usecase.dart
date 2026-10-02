import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/bill_inquiry.dart';
import 'package:payinall/domain/params/bill_inquiry_params.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';

final class GetBillInquiryUsecase
    implements BaseUsecase<List<BillInquiry>, BillInquiryParams> {
  GetBillInquiryUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, List<BillInquiry>>> call(
    BillInquiryParams params,
  ) async {
    final result = await repository.getBillInquiry(params);
    return result;
  }
}
