part of 'change_phone_bloc.dart';

sealed class ChangePhoneEvent {
  const ChangePhoneEvent();
}

final class ChangePhoneLoad extends ChangePhoneEvent {
  const ChangePhoneLoad();
}

final class ChangePhoneSubmit extends ChangePhoneEvent {
  const ChangePhoneSubmit({
    required this.identityNumber,
    required this.newPhoneNumber,
    required this.securityQuestionAnswer,
  });

  final String identityNumber;
  final String newPhoneNumber;
  final String securityQuestionAnswer;
}
