import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/office.dart';
import 'package:payinall/domain/params/get_offices_params.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetOfficesUsecase
    implements BaseUsecase<List<Office>, GetOfficesParams> {
  GetOfficesUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, List<Office>>> call(
    GetOfficesParams params,
  ) async {
    return repository.getOffices(params);
  }
}
