part of 'sms_verification_bloc.dart';

sealed class SmsVerificationEvent {
  const SmsVerificationEvent();
}

final class RegisterSmsVerificationSubmit extends SmsVerificationEvent {
  const RegisterSmsVerificationSubmit({
    required this.pin,
    required this.processCode,
  });

  final String pin;
  final String processCode;
}

final class RegisterSmsVerificationResend extends SmsVerificationEvent {
  const RegisterSmsVerificationResend({required this.phoneNumber});
  final String phoneNumber;
}

final class LoginSmsVerificationSubmit extends SmsVerificationEvent {
  const LoginSmsVerificationSubmit({
    required this.pin,
    required this.processCode,
  });

  final String pin;
  final String processCode;
}

final class LoginSmsVerificationResend extends SmsVerificationEvent {
  const LoginSmsVerificationResend({required this.processCode});
  final String processCode;
}

final class MerchantLoginSmsVerificationSubmit extends SmsVerificationEvent {
  const MerchantLoginSmsVerificationSubmit({
    required this.pin,
    required this.processCode,
  });

  final String pin;
  final String processCode;
}

final class ChangePhoneNumberSmsVerificationSubmit
    extends SmsVerificationEvent {
  const ChangePhoneNumberSmsVerificationSubmit({
    required this.pin,
    required this.processCode,
  });

  final String pin;
  final String processCode;
}

final class ChangePhoneNumberSmsVerificationResend
    extends SmsVerificationEvent {
  const ChangePhoneNumberSmsVerificationResend({
    required this.newPhoneNumber,
    required this.identityNumber,
    required this.securityQuestionAnswer,
  });
  final String newPhoneNumber;
  final String identityNumber;
  final String securityQuestionAnswer;
}

final class SmsVerificationTimerStart extends SmsVerificationEvent {
  const SmsVerificationTimerStart({required this.processCode});
  final String processCode;
}

final class SmsVerificationTimerReStart extends SmsVerificationEvent {
  const SmsVerificationTimerReStart({required this.processCode});
  final String processCode;
}

final class SmsVerificationTimerTick extends SmsVerificationEvent {
  const SmsVerificationTimerTick();
}

final class SmsVerificationTimerComplete extends SmsVerificationEvent {
  const SmsVerificationTimerComplete();
}

final class TimerState {
  const TimerState({required this.remainingTime, required this.canResend});

  final int remainingTime;
  final bool canResend;
}
