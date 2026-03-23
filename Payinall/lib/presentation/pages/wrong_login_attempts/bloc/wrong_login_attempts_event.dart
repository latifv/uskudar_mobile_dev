part of 'wrong_login_attempts_bloc.dart';

sealed class WrongLoginAttemptsEvent {
  const WrongLoginAttemptsEvent();
}

final class WrongLoginAttemptsLoadData extends WrongLoginAttemptsEvent {
  const WrongLoginAttemptsLoadData();
}
