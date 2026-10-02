import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';
import 'package:uskudar_mobile/domain/params/check_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/check_merchant_activation_code_params.dart';
import 'package:uskudar_mobile/domain/params/send_new_code_params.dart';

abstract interface class CustomerActivationsRepository {
  Future<Either<Failure, DataWithMessage<String>>> sendNewCode(
    SendNewCodeParams params,
  );
  Future<Either<Failure, AuthToken>> checkActivationCode(
    CheckActivationCodeParams params,
  );
  Future<Either<Failure, AuthToken>> checkMerchantActivationCode(
    CheckMerchantActivationCodeParams params,
  );
}
