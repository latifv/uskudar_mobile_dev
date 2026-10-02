import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/commission.dart';

abstract interface class CommissionsRepository {
  Future<Either<Failure, List<Commission>>> getActiveList();
  Future<Either<Failure, List<Commission>>> getMerchantCommissions();
}
