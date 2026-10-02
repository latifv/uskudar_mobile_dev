import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/onboarding/enum/onboarding_page.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

final class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
    : super(const OnboardingLoaded(page: OnboardingPage.welcome)) {
    on<OnboardingNext>(_onOnboardingNext);
    on<OnboardingSkip>(_onOnboardingSkip);
  }

  Future<void> _onOnboardingNext(
    OnboardingNext event,
    Emitter<OnboardingState> emit,
  ) async {
    final page = (state as OnboardingLoaded).page;

    switch (page) {
      case OnboardingPage.welcome:
        emit(const OnboardingLoaded(page: OnboardingPage.welcome2));
      case OnboardingPage.welcome2:
        emit(const OnboardingLoaded(page: OnboardingPage.welcome3));
      case OnboardingPage.welcome3:
        emit(const OnboardingCompleted());
    }
  }

  Future<void> _onOnboardingSkip(
    OnboardingSkip event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingCompleted());
  }
}
