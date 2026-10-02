import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/add_frequent_iban_params.dart';
import 'package:uskudar_mobile/domain/repositories/frequent_ibans_repository.dart';

final class AddFrequentIbanUsecase
    implements BaseUsecase<String, AddFrequentIbanParams> {
  AddFrequentIbanUsecase(this.repository);

  final FrequentIbansRepository repository;

  @override
  Future<Either<Failure, String>> call(AddFrequentIbanParams params) async {
    final result = await repository.addFrequentIban(params);
    return result;
  }
}
