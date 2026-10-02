import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/address_number_inquiry_params.dart';
import 'package:payinall/domain/repositories/user_address_informations_repository.dart';

final class AddressNumberInquiryUsecase
    implements BaseUsecase<void, AddressNumberInquiryParams> {
  AddressNumberInquiryUsecase(this.repository);

  final UserAddressInformationsRepository repository;

  @override
  Future<Either<Failure, void>> call(AddressNumberInquiryParams params) async {
    final result = await repository.addressNumberInquiry(params);
    return result;
  }
}
