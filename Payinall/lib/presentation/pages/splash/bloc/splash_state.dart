part of 'splash_bloc.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

final class SplashOnboarding extends SplashState {
  const SplashOnboarding();
}

final class SplashLoggedIn extends SplashState {
  const SplashLoggedIn({required this.loggedIn});

  final LoggedIn loggedIn;

  @override
  List<Object?> get props => [loggedIn];
}

final class SplashNotLoggedIn extends SplashState {
  const SplashNotLoggedIn();
}

final class SplashError extends SplashState {
  const SplashError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class SplashJailbroken extends SplashState {
  const SplashJailbroken();
}

final class SplashLanguageSelection extends SplashState {
  const SplashLanguageSelection();
}
