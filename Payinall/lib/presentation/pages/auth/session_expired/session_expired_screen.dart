import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: context.paddingNormalAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(context),
              context.spacingNormalHeight,
              _buildTitle(context),
              context.spacingNormalHeight,
              _buildDescription(context),
              context.spacingNormalHeight,
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Icon(
      Icons.access_time,
      size: IconSizeConstants.xxl,
      color: context.colorScheme.primary,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      LocaleKeys.session_expired_title.translate,
      style: context.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      LocaleKeys.session_expired.translate,
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PrimaryElevatedButton(
        onPressed: () {
          unawaited(context.router.replaceAll([LoginRoute()]));
        },
        text: LocaleKeys.login.translate,
      ),
    );
  }
}
