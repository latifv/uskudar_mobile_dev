import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/user_address_information.dart';
import 'package:uskudar_mobile/domain/params/address_number_inquiry_params.dart';
import 'package:uskudar_mobile/domain/params/get_user_address_information_params.dart';
import 'package:uskudar_mobile/domain/params/user_address_information_approve_params.dart';

abstract interface class UserAddressInformationsRepository {
  Future<Either<Failure, void>> addressNumberInquiry(
    AddressNumberInquiryParams params,
  );

  Future<Either<Failure, UserAddressInformation>> getUserAddressInformation(
    GetUserAddressInformationParams params,
  );

  Future<Either<Failure, void>> userAddressInformationApprove(
    UserAddressInformationApproveParams params,
  );
}
