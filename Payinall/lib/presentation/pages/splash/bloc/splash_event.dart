part of 'splash_bloc.dart';

sealed class SplashEvent {
  const SplashEvent();
}

final class SplashInitServices extends SplashEvent {
  const SplashInitServices();
}

final class _SplashStarted extends SplashEvent {
  const _SplashStarted();
}
