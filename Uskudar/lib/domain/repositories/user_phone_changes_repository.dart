import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/params/change_phone_code_params.dart';
import 'package:payinall/domain/params/change_phone_params.dart';

abstract interface class UserPhoneChangesRepository {
  Future<Either<Failure, DataWithMessage<String>>> changePhoneCode(
    ChangePhoneCodeParams params,
  );
  Future<Either<Failure, String>> changePhone(ChangePhoneParams params);
}
