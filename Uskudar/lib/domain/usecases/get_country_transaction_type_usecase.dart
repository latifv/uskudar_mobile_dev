import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/country_transaction_type.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetCountryTransactionTypeUsecase
    implements BaseUsecase<CountryTransactionType, String> {
  GetCountryTransactionTypeUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, CountryTransactionType>> call(
    String countryCode,
  ) async {
    return repository.getCountryTransactionType(countryCode);
  }
}
