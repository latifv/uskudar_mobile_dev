import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/customer_bank.dart';
import 'package:payinall/domain/params/customer_banks_params.dart';

abstract interface class CustomerBanksRepository {
  Future<Either<Failure, List<CustomerBank>>> getBanks();
  Future<Either<Failure, void>> addBank(CustomerBanksParams params);
  Future<Either<Failure, void>> addMerchantBank(CustomerBanksParams params);
  Future<Either<Failure, void>> deleteBank(String ibanNumber);
}
