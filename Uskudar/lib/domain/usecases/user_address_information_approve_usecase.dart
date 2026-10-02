import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/user_address_information_approve_params.dart';
import 'package:payinall/domain/repositories/user_address_informations_repository.dart';

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
