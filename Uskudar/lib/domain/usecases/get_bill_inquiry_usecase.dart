import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/bill_inquiry.dart';
import 'package:uskudar_mobile/domain/params/bill_inquiry_params.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

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
