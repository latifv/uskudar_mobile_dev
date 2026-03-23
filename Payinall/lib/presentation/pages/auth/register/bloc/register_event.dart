part of 'register_bloc.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

final class RegisterSubmit extends RegisterEvent {
  const RegisterSubmit(this.phoneNumber);

  final String phoneNumber;
}

final class RegisterAgreementChange extends RegisterEvent {
  const RegisterAgreementChange({
    required this.agreementType,
    required this.isAccepted,
  });

  final AgreementType agreementType;
  final bool isAccepted;
}
