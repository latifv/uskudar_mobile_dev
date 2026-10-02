import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';
import 'package:uskudar_mobile/domain/params/change_phone_params.dart';

abstract interface class UserPhoneChangesRepository {
  Future<Either<Failure, DataWithMessage<String>>> changePhoneCode(
    ChangePhoneCodeParams params,
  );
  Future<Either<Failure, String>> changePhone(ChangePhoneParams params);
}
