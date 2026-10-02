import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/nfc_response.dart';
import 'package:payinall/domain/entities/nfc.dart';

final class NfcModel extends Nfc {
  const NfcModel({required super.image});

  factory NfcModel.fromResponse(NfcResponse response) {
    if (response.image == null) {
      throw const MappingException();
    }

    return NfcModel(image: response.image!);
  }
}
