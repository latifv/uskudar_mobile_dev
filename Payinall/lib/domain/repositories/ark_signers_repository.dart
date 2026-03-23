import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/nfc.dart';
import 'package:payinall/domain/params/back_image_check_params.dart';
import 'package:payinall/domain/params/face_image_check_params.dart';
import 'package:payinall/domain/params/front_image_check_params.dart';
import 'package:payinall/domain/params/nfc_check_params.dart';

abstract interface class ArkSignersRepository {
  Future<Either<Failure, String>> frontImageCheck(FrontImageCheckParams params);
  Future<Either<Failure, void>> backImageCheck(BackImageCheckParams params);
  Future<Either<Failure, void>> faceImageCheck(FaceImageCheckParams params);
  Future<Either<Failure, Nfc>> nfcCheck(NfcCheckParams params);
}
