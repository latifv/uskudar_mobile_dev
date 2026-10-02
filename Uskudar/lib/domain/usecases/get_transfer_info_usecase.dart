import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';

final class GetTransferInfoUsecase implements BaseUsecase<String, String> {
  GetTransferInfoUsecase(this.repository);

  final InternationalMoneyTransferRepository repository;

  @override
  Future<Either<Failure, String>> call(String referenceNumber) async {
    final result = await repository.getTransferInfo(referenceNumber);
    return result;
  }
}
