part of 'change_email_bloc.dart';

sealed class ChangeEmailEvent {
  const ChangeEmailEvent();
}

final class ChangeEmailSubmit extends ChangeEmailEvent {
  const ChangeEmailSubmit({required this.newEmailAddress});
  final String newEmailAddress;
}

final class ChangeEmailReset extends ChangeEmailEvent {
  const ChangeEmailReset();
}
