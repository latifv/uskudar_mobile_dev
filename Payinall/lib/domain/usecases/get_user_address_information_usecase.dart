import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/user_address_information.dart';
import 'package:payinall/domain/params/get_user_address_information_params.dart';
import 'package:payinall/domain/repositories/user_address_informations_repository.dart';

final class GetUserAddressInformationUsecase
    implements
        BaseUsecase<UserAddressInformation, GetUserAddressInformationParams> {
  GetUserAddressInformationUsecase(this.repository);

  final UserAddressInformationsRepository repository;

  @override
  Future<Either<Failure, UserAddressInformation>> call(
    GetUserAddressInformationParams params,
  ) async {
    final result = await repository.getUserAddressInformation(params);
    return result;
  }
}
