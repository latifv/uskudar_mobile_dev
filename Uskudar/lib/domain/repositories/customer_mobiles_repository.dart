import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/params/customer_mobiles_params.dart';

abstract interface class CustomerMobilesRepository {
  Future<Either<Failure, void>> customerMobiles(CustomerMobilesParams params);
}
