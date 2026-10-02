import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/nfc.dart';
import 'package:uskudar_mobile/domain/params/back_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/face_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/front_image_check_params.dart';
import 'package:uskudar_mobile/domain/params/nfc_check_params.dart';

abstract interface class ArkSignersRepository {
  Future<Either<Failure, String>> frontImageCheck(FrontImageCheckParams params);
  Future<Either<Failure, void>> backImageCheck(BackImageCheckParams params);
  Future<Either<Failure, void>> faceImageCheck(FaceImageCheckParams params);
  Future<Either<Failure, Nfc>> nfcCheck(NfcCheckParams params);
}
