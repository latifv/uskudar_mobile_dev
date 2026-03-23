import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:payinall/presentation/pages/onboarding/enum/onboarding_page.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin OnboardingMixin<T extends StatefulWidget> on State<T> {
  late final PageController pageController;
  late final OnboardingBloc bloc;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    bloc = getIt<OnboardingBloc>();
  }

  @override
  void dispose() {
    pageController.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, OnboardingState state) {
    if (state is OnboardingCompleted) {
      unawaited(context.router.replace(LoginRoute()));
    } else if (state is OnboardingLoaded) {
      if (state.page != OnboardingPage.welcome) {
        unawaited(
          pageController.animateToPage(
            state.page.getIndex,
            duration: Durations.long2,
            curve: Curves.easeOut,
          ),
        );
      }
    }
  }

  void onPageChanged() {
    bloc.add(const OnboardingNext());
  }

  void onSkip() {
    bloc.add(const OnboardingSkip());
  }
}
