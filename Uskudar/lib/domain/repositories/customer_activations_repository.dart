import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/entities/auth_token.dart';
import 'package:payinall/domain/params/check_activation_code_params.dart';
import 'package:payinall/domain/params/check_merchant_activation_code_params.dart';
import 'package:payinall/domain/params/send_new_code_params.dart';

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
