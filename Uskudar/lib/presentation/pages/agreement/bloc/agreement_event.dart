part of 'agreement_bloc.dart';

sealed class AgreementEvent {
  const AgreementEvent();
}

final class GetAgreement extends AgreementEvent {
  const GetAgreement({required this.agreementType});

  final AgreementType agreementType;
}

final class DeclineAgreement extends AgreementEvent {
  const DeclineAgreement();
}
