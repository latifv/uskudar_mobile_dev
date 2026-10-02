import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/office.dart';
import 'package:uskudar_mobile/domain/params/get_offices_params.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';

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
