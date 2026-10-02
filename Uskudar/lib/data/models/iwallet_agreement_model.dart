import 'package:uskudar_mobile/data/dtos/responses/iwallet_agreement_response.dart';
import 'package:uskudar_mobile/domain/entities/iwallet_agreement.dart';

final class IWalletAgreementModel extends IWalletAgreement {
  const IWalletAgreementModel({
    required super.htmlFile,
    required super.name,
    required super.pdfFile,
    required super.shortName,
    required super.version,
  });

  factory IWalletAgreementModel.fromResponse(
    IWalletAgreementResponse response,
  ) {
    return IWalletAgreementModel(
      htmlFile: response.htmlFile,
      name: response.name,
      pdfFile: response.pdfFile,
      shortName: response.shortName,
      version: response.version,
    );
  }
}
