import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/notification_settings/bloc/notification_settings_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/notification_settings/mixin/notification_settings_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/notification_settings/widgets/notification_setting_item.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/info_dialog.dart';

@RoutePage()
final class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

final class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen>
    with NotificationSettingsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.notification_settings.translate),
        ),
        body: BlocListener<NotificationSettingsBloc, NotificationSettingsState>(
          listenWhen: (previous, current) => current.operationState != null,
          listener: _blocListener,
          child:
              BlocBuilder<NotificationSettingsBloc, NotificationSettingsState>(
                builder: (_, state) {
                  if (state.state == NotificationSettingsBlocState.loading) {
                    return const Center(child: CustomLoading());
                  } else if (state.state ==
                      NotificationSettingsBlocState.error) {
                    return ErrorTryAgain(
                      onTryAgain: loadSettings,
                      message: state.message,
                    );
                  } else if (state.state ==
                      NotificationSettingsBlocState.loaded) {
                    return SingleChildScrollView(
                      padding: context.paddingBase,
                      child: _buildContent(state),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
        ),
      ),
    );
  }

  void _blocListener(_, NotificationSettingsState state) {
    if (state.operationState == NotificationOperationState.success) {
      unawaited(
        InfoDialog.show(
          barrierDismissible: false,
          context: context,
          title: LocaleKeys.success_with_message.translate,
          description: LocaleKeys.notification_settings_updated.translate,
          icon: Icons.check_circle_outline,
          iconColor: context.colorScheme.primary,
          duration: const Duration(seconds: 2),
          buttonActive: false,
        ),
      );
    } else if (state.operationState == NotificationOperationState.error) {
      unawaited(
        InfoDialog.show(
          barrierDismissible: false,
          context: context,
          title: LocaleKeys.error.translate,
          description: state.message ?? LocaleKeys.unknown_error.translate,
          icon: Icons.error_outline,
          iconColor: context.colorScheme.error,
          duration: const Duration(seconds: 2),
          buttonActive: false,
        ),
      );
    }

    bloc.add(const NotificationSettingsResetOperationState());
  }

  Widget _buildContent(NotificationSettingsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderText(),
        context.spacingNormalHeight,
        ...state.settings!.map((setting) {
          return Column(
            children: [
              NotificationSettingItem(
                setting: setting,
                onSelect: (type) => selectNotificationType(context, type),
              ),
              context.spacingLowHeight,
              if (setting != state.settings!.last)
                Divider(
                  color: context.colorScheme.onSurface.withAlpha(50),
                  thickness: 0.5,
                  height: 1,
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildHeaderText() {
    return Text(
      LocaleKeys.notification_settings_description.translate,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withAlpha(164),
      ),
    );
  }
}
