import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

final class ArkErrorConstants {
  const ArkErrorConstants._();

  static String selfieError(String id) {
    switch (id) {
      case '0':
        return LocaleKeys.selfie_error_unknown.translate;
      case '1':
        return LocaleKeys.selfie_error_multiple_faces.translate;
      case '2':
        return LocaleKeys.selfie_error_face_lost.translate;
      case '3':
        return LocaleKeys.selfie_error_no_camera.translate;
      case '4':
        return LocaleKeys.selfie_error_low_brightness.translate;
      case '5':
        return LocaleKeys.selfie_error_permission_denied_perm.translate;
      case '6':
        return LocaleKeys.selfie_error_permission_denied.translate;
      case '18':
        return LocaleKeys.selfie_error_wrong_direction.translate;
      default:
        return LocaleKeys.unknown_error.translate;
    }
  }

  static String backSideError(String id) {
    switch (id) {
      case '0':
        return LocaleKeys.back_side_error_not_read.translate;
      case '1':
        return LocaleKeys.camera_permission_denied.translate;
      case '2':
        return LocaleKeys.camera_permission_denied.translate;
      case '3':
        return LocaleKeys.no_camera_available.translate;
      case '4':
        return LocaleKeys.timeout_invalid.translate;
      default:
        return LocaleKeys.unknown_error.translate;
    }
  }

  static String frontSideError(String id) {
    switch (id) {
      case '0':
        return LocaleKeys.front_side_error_not_read.translate;
      case '1':
        return LocaleKeys.camera_permission_denied.translate;
      case '2':
        return LocaleKeys.camera_permission_denied.translate;
      case '3':
        return LocaleKeys.no_camera_available.translate;
      case '4':
        return LocaleKeys.timeout_invalid.translate;
      default:
        return LocaleKeys.unknown_error.translate;
    }
  }

  static String nfcError(String id) {
    switch (id) {
      case '0':
        return LocaleKeys.nfc_error_unknown.translate;
      case '1':
        return LocaleKeys.nfc_error_chip_read.translate;
      case '2':
        return LocaleKeys.nfc_error_invalid_value.translate;
      case '3':
        return LocaleKeys.nfc_error_not_available.translate;
      case '4':
        return LocaleKeys.nfc_error_chip_not_supported.translate;
      case '5':
        return LocaleKeys.nfc_error_connect_failed.translate;
      case '6':
        return LocaleKeys.nfc_error_chip_not_supported.translate;
      case '7':
        return LocaleKeys.nfc_error_comm_lost.translate;
      case '8':
        return LocaleKeys.nfc_error_validation_failed.translate;
      case '9':
        return LocaleKeys.nfc_error_feature_disabled.translate;
      default:
        return LocaleKeys.unknown_error.translate;
    }
  }
}
