import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/nfc_check_params.dart';

part 'nfc_check_request.g.dart';

@JsonSerializable(createFactory: false)
final class NfcCheckRequest extends NfcCheckParams {
  const NfcCheckRequest({
    required super.processId,
    required super.dg1Base64,
    required super.dg2Base64,
    required super.dg3Base64,
    required super.dg4Base64,
    required super.dg5Base64,
    required super.dg6Base64,
    required super.dg7Base64,
    required super.dg8Base64,
    required super.dg9Base64,
    required super.dg10Base64,
    required super.dg11Base64,
    required super.dg12Base64,
    required super.dg13Base64,
    required super.dg14Base64,
    required super.dg15Base64,
    required super.dg16Base64,
    required super.efComBase64,
    required super.challengeBase64,
    required super.activeAuthenticationResponseBase64,
    required super.mrz,
    required super.efSodBase64,
  });

  factory NfcCheckRequest.fromParams(NfcCheckParams params) {
    return NfcCheckRequest(
      processId: params.processId,
      dg1Base64: params.dg1Base64,
      dg2Base64: params.dg2Base64,
      dg3Base64: params.dg3Base64,
      dg4Base64: params.dg4Base64,
      dg5Base64: params.dg5Base64,
      dg6Base64: params.dg6Base64,
      dg7Base64: params.dg7Base64,
      dg8Base64: params.dg8Base64,
      dg9Base64: params.dg9Base64,
      dg10Base64: params.dg10Base64,
      dg11Base64: params.dg11Base64,
      dg12Base64: params.dg12Base64,
      dg13Base64: params.dg13Base64,
      dg14Base64: params.dg14Base64,
      dg15Base64: params.dg15Base64,
      dg16Base64: params.dg16Base64,
      efComBase64: params.efComBase64,
      challengeBase64: params.challengeBase64,
      activeAuthenticationResponseBase64:
          params.activeAuthenticationResponseBase64,
      mrz: params.mrz,
      efSodBase64: params.efSodBase64,
    );
  }

  Map<String, dynamic> toJson() => _$NfcCheckRequestToJson(this);
}
