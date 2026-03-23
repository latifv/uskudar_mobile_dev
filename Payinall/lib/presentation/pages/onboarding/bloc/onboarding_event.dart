part of 'onboarding_bloc.dart';

sealed class OnboardingEvent {
  const OnboardingEvent();
}

final class OnboardingNext extends OnboardingEvent {
  const OnboardingNext();
}

final class OnboardingSkip extends OnboardingEvent {
  const OnboardingSkip();
}
