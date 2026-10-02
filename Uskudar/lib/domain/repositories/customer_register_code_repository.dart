import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/params/check_register_code_params.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';

abstract interface class CustomerRegisterCodeRepository {
  Future<Either<Failure, DataWithMessage<String>>> createRegisterCode(
    CreateRegisterCodeParams params,
  );
  Future<Either<Failure, String>> checkRegisterCode(
    CheckRegisterCodeParams params,
  );
}
