import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/commission.dart';

abstract interface class CommissionsRepository {
  Future<Either<Failure, List<Commission>>> getActiveList();
  Future<Either<Failure, List<Commission>>> getMerchantCommissions();
}
