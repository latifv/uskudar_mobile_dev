import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/auth_mobile.dart';
import 'package:uskudar_mobile/domain/params/auth_mobile_params.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';

final class AuthMobileUsecase
    implements BaseUsecase<AuthMobile, AuthMobileParams> {
  AuthMobileUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthMobile>> call(AuthMobileParams params) async {
    final result = await repository.authMobile(params);
    return result;
  }
}
