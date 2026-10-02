import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/user_address_information.dart';
import 'package:uskudar_mobile/domain/params/get_user_address_information_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_address_informations_repository.dart';

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
