import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/auth_mobile.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';
import 'package:uskudar_mobile/domain/params/auth_merchant_params.dart';
import 'package:uskudar_mobile/domain/params/auth_mobile_params.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthMobile>> authMobile(AuthMobileParams params);
  Future<Either<Failure, AuthMobile>> authMerchant(AuthMerchantParams params);
  Future<Either<Failure, LoggedIn?>> getLoggedIn();
  Future<Either<Failure, void>> saveLoggedIn(LoggedIn loggedIn);
}
