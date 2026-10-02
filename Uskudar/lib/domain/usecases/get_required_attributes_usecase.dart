import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/corporation_attribute.dart';
import 'package:payinall/domain/params/get_required_attributes_params.dart';
import 'package:payinall/domain/repositories/international_money_transfer_repository.dart';

final class GetRequiredAttributesUsecase
    implements
        BaseUsecase<List<CorporationAttribute>, GetRequiredAttributesParams> {
  GetRequiredAttributesUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, List<CorporationAttribute>>> call(
    GetRequiredAttributesParams params,
  ) async {
    final result = await repository.getRequiredAttributes(params);
    return result;
  }
}
