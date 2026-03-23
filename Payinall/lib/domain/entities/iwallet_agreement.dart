class IWalletAgreement {
  const IWalletAgreement({
    required this.htmlFile,
    required this.name,
    required this.pdfFile,
    required this.shortName,
    required this.version,
  });

  final String htmlFile;
  final String name;
  final String pdfFile;
  final String shortName;
  final String version;
}
