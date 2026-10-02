import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/address_number_inquiry_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_address_informations_repository.dart';

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
