part of 'security_change_phone_bloc.dart';

sealed class SecurityChangePhoneEvent {
  const SecurityChangePhoneEvent();
}

final class SecurityChangePhoneSubmit extends SecurityChangePhoneEvent {
  const SecurityChangePhoneSubmit(this.tcNumber);

  final String tcNumber;
}
