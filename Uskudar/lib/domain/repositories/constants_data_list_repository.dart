import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/constants_data.dart';

abstract interface class ConstantsDataListRepository {
  Future<Either<Failure, List<ConstantsData>>> getAverageRevenueTypes();
  Future<Either<Failure, List<ConstantsData>>>
  getMonthlyTransactionCountTypes();
}
