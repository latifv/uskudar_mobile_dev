import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/country_transaction_type.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';

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
