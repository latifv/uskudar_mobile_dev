part of 'metropol_bloc.dart';

sealed class MetropolEvent {
  const MetropolEvent();
}

final class MetropolLoad extends MetropolEvent {
  const MetropolLoad();
}

final class MetropolRefreshBalance extends MetropolEvent {
  const MetropolRefreshBalance();
}
