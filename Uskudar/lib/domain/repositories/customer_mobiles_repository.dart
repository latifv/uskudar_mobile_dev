import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/params/customer_mobiles_params.dart';

abstract interface class CustomerMobilesRepository {
  Future<Either<Failure, void>> customerMobiles(CustomerMobilesParams params);
}
