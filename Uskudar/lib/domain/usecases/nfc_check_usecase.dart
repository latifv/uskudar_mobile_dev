import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/nfc.dart';
import 'package:payinall/domain/params/nfc_check_params.dart';
import 'package:payinall/domain/repositories/ark_signers_repository.dart';

final class NfcCheckUsecase implements BaseUsecase<Nfc, NfcCheckParams> {
  NfcCheckUsecase(this.repository);

  final ArkSignersRepository repository;

  @override
  Future<Either<Failure, Nfc>> call(NfcCheckParams params) async {
    final result = await repository.nfcCheck(params);
    return result;
  }
}
