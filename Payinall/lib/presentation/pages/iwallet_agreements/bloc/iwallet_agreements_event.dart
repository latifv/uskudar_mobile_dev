part of 'iwallet_agreements_bloc.dart';

sealed class IWalletAgreementsEvent {
  const IWalletAgreementsEvent();
}

final class GetIWalletAgreements extends IWalletAgreementsEvent {
  const GetIWalletAgreements();
}

final class LoadAgreementHtml extends IWalletAgreementsEvent {
  const LoadAgreementHtml({
    required this.shortName,
    required this.htmlUrl,
  });

  final String shortName;
  final String htmlUrl;
}

final class AcceptCurrentAgreement extends IWalletAgreementsEvent {
  const AcceptCurrentAgreement();
}
