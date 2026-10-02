import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/add_frequent_iban_params.dart';
import 'package:payinall/domain/repositories/frequent_ibans_repository.dart';

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
