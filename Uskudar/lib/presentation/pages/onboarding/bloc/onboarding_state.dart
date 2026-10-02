part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingLoaded extends OnboardingState {
  const OnboardingLoaded({required this.page});

  final OnboardingPage page;

  @override
  List<Object?> get props => [page];
}

final class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}
