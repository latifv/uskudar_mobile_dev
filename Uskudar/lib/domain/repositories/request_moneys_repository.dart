import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/request_money.dart';
import 'package:uskudar_mobile/domain/params/request_moneys_params.dart';

abstract interface class RequestMoneysRepository {
  Future<Either<Failure, void>> requestMoney(RequestMoneyParams params);
  Future<Either<Failure, void>> deleteRequestMoney(int id);
  Future<Either<Failure, List<RequestMoney>>> getSenderRequestMoneys();
  Future<Either<Failure, List<RequestMoney>>> getBuyerRequestMoneys();
}
