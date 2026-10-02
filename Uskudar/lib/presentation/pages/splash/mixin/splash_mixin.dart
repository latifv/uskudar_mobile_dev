import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';

mixin SplashMixin<T extends StatefulWidget> on State<T> {
  late final SplashBloc bloc;

  @override
  void initState() {
    bloc = getIt<SplashBloc>();
    super.initState();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, SplashState state) {
    if (state is SplashLanguageSelection) {
      unawaited(context.router.replace(const LanguageSelectionRoute()));
    } else if (state is SplashOnboarding) {
      unawaited(context.router.replace(const OnboardingRoute()));
    } else if (state is SplashJailbroken) {
      unawaited(_showJailbrokenDialog());
    } else if (state is SplashNotLoggedIn) {
      unawaited(context.router.replace(LoginRoute()));
    } else if (state is SplashLoggedIn) {
      final loggedIn = state.loggedIn;
      final identifier = loggedIn.identifier;
      unawaited(
        context.router.replace(
          PasswordConfirmationRoute(
            identifier: identifier,
          ),
        ),
      );
    }
  }

  Future<void> _showJailbrokenDialog() async {
    await CustomDialog.show(
      context: context,
      title: LocaleKeys.security.translate,
      description: LocaleKeys.jailbreak_warning_description.translate,
      icon: Icons.security_rounded,
      primaryButtonText: LocaleKeys.close.translate,
      onPrimaryButtonPressed: SystemNavigator.pop,
      barrierDismissible: false,
      surfaceButtonActive: false,
    );
  }
}
