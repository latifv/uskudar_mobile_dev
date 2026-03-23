part of 'email_verification_bloc.dart';

sealed class EmailVerificationEvent {
  const EmailVerificationEvent();
}

final class EmailUpdateVerificationSubmit extends EmailVerificationEvent {
  const EmailUpdateVerificationSubmit({
    required this.code,
    required this.processCode,
  });

  final String code;
  final String processCode;
}

final class EmailChangeVerificationSubmit extends EmailVerificationEvent {
  const EmailChangeVerificationSubmit({
    required this.code,
    required this.processCode,
  });

  final String code;
  final String processCode;
}

final class EmailUpdateVerificationResend extends EmailVerificationEvent {
  const EmailUpdateVerificationResend();
}

final class EmailChangeVerificationResend extends EmailVerificationEvent {
  const EmailChangeVerificationResend({required this.newEmailAddress});
  final String newEmailAddress;
}

final class EmailVerificationTimerStart extends EmailVerificationEvent {
  const EmailVerificationTimerStart({required this.processCode});
  final String processCode;
}

final class EmailVerificationTimerReStart extends EmailVerificationEvent {
  const EmailVerificationTimerReStart({required this.processCode});
  final String processCode;
}

final class EmailVerificationTimerTick extends EmailVerificationEvent {
  const EmailVerificationTimerTick();
}

final class EmailVerificationTimerComplete extends EmailVerificationEvent {
  const EmailVerificationTimerComplete();
}

final class EmailTimerState {
  const EmailTimerState({required this.remainingTime, required this.canResend});

  final int remainingTime;
  final bool canResend;
}
