import 'package:json_annotation/json_annotation.dart';

part 'iwallet_agreement_response.g.dart';

@JsonSerializable(createToJson: false)
final class IWalletAgreementResponse {
  const IWalletAgreementResponse({
    required this.htmlFile,
    required this.name,
    required this.pdfFile,
    required this.shortName,
    required this.version,
  });

  factory IWalletAgreementResponse.fromJson(Map<String, dynamic> json) =>
      _$IWalletAgreementResponseFromJson(json);

  @JsonKey(name: 'html_file')
  final String htmlFile;

  final String name;

  @JsonKey(name: 'pdf_file')
  final String pdfFile;

  @JsonKey(name: 'short_name')
  final String shortName;

  final String version;
}
