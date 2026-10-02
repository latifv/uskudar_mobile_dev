import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/nfc.dart';
import 'package:uskudar_mobile/domain/params/nfc_check_params.dart';
import 'package:uskudar_mobile/domain/repositories/ark_signers_repository.dart';

final class NfcCheckUsecase implements BaseUsecase<Nfc, NfcCheckParams> {
  NfcCheckUsecase(this.repository);

  final ArkSignersRepository repository;

  @override
  Future<Either<Failure, Nfc>> call(NfcCheckParams params) async {
    final result = await repository.nfcCheck(params);
    return result;
  }
}
