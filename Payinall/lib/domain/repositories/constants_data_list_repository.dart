import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/constants_data.dart';

abstract interface class ConstantsDataListRepository {
  Future<Either<Failure, List<ConstantsData>>> getAverageRevenueTypes();
  Future<Either<Failure, List<ConstantsData>>>
  getMonthlyTransactionCountTypes();
}
