import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/country.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetCountryListUsecase
    implements BaseUsecaseWithoutParams<List<Country>> {
  GetCountryListUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, List<Country>>> call() async {
    return repository.getCountryList();
  }
}
