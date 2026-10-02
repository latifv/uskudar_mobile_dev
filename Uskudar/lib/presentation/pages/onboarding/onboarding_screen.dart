import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/onboarding/enum/onboarding_page.dart';
import 'package:uskudar_mobile/presentation/pages/onboarding/mixin/onboarding_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_page_indicator.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

final class _OnboardingScreenState extends State<OnboardingScreen>
    with OnboardingMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listener: blocListener,
        child: Scaffold(
          body: BlocBuilder<OnboardingBloc, OnboardingState>(
            builder: (_, state) {
              return switch (state) {
                OnboardingLoaded() => _buildBody(state.page),
                OnboardingCompleted() => const Center(
                  child: CustomLoading(),
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(OnboardingPage page) {
    return Stack(
      children: [
        _buildPageView(page),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: context.dynamicHeight(0.7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.15, 0.35, 0.55, 1.0],
                colors: [
                  Colors.white.withValues(alpha: 0),
                  Colors.white.withValues(alpha: 0.6),
                  Colors.white.withValues(alpha: 0.9),
                  Colors.white,
                  Colors.white,
                ],
              ),
            ),
            child: _buildBottomSection(page),
          ),
        ),
      ],
    );
  }

  // Widget _buildHeader() {
  //   return Padding(
  //     padding: context.paddingBase,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         _buildSkipButton(),
  //         _buildPageIndicator(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildPageView(OnboardingPage page) {
    return PageView.builder(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: OnboardingPage.values.length,
      itemBuilder: (_, index) => _buildPage(OnboardingPage.values[index]),
    );
  }

  // Widget _buildSkipButton() {
  //   return CustomTextButton(
  //     onPressed: onSkip,
  //     text: LocaleKeys.skip.translate,
  //     textStyle: context.textTheme.bodyMedium?.copyWith(
  //       color: Colors.grey[600],
  //       fontWeight: FontWeight.w600,
  //     ),
  //   );
  // }

  Widget _buildPage(OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.getImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return CustomPageIndicator(
      pageController: pageController,
      count: OnboardingPage.values.length,
    );
  }

  Widget _buildBottomSection(OnboardingPage page) {
    return Padding(
      padding: context.paddingBase,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            page.getTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          context.spacingNormalHeight,
          Text(
            page.getDescription,
            style: context.textTheme.bodyLarge?.copyWith(),
            textAlign: TextAlign.center,
          ),
          context.spacingNormalHeight,
          _buildPageIndicator(),
          context.spacingHighHeight,
          _buildNextButton(),
          context.spacingMediumHeight,
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return PrimaryElevatedButton(
      onPressed: onPageChanged,
      text: LocaleKeys.next.translate,
    );
  }
}
