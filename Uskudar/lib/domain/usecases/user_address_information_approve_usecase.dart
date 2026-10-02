import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/user_address_information_approve_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_address_informations_repository.dart';

final class UserAddressInformationApproveUsecase
    implements BaseUsecase<void, UserAddressInformationApproveParams> {
  UserAddressInformationApproveUsecase(this.repository);

  final UserAddressInformationsRepository repository;

  @override
  Future<Either<Failure, void>> call(
    UserAddressInformationApproveParams params,
  ) async {
    final result = await repository.userAddressInformationApprove(params);
    return result;
  }
}
