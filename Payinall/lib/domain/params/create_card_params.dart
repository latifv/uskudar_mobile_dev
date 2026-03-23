class CreateCardParams {
  const CreateCardParams({
    required this.individualFrameworkAgreement,
    required this.preliminaryInformationAgreement,
    required this.commercialElectronicCommunicationAgreement,
    required this.kvkkAgreement,
  });

  final bool individualFrameworkAgreement;
  final bool preliminaryInformationAgreement;
  final bool commercialElectronicCommunicationAgreement;
  final bool kvkkAgreement;
}
