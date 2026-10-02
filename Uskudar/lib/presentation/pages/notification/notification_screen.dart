import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';
import 'package:uskudar_mobile/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/notification/mixin/notification_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

final class _NotificationScreenState extends State<NotificationScreen>
    with NotificationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.notifications.translate),
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            bloc: bloc,
            builder: (_, state) {
              if (state is NotificationLoaded &&
                  state.notifications.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () => CustomDialog.show(
                    context: context,
                    title: LocaleKeys.clear_all.translate,
                    description: LocaleKeys.clear_all_description.translate,
                    icon: Icons.delete_sweep,
                    primaryButtonText: LocaleKeys.clear_all.translate,
                    onPrimaryButtonPressed: clearAllNotifications,
                  ),
                  tooltip: LocaleKeys.clear_all.translate,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        bloc: bloc,
        builder: (_, state) {
          if (state is NotificationInitial || state is NotificationLoading) {
            return const Center(child: CustomLoading());
          }

          if (state is NotificationError) {
            return ErrorTryAgain(
              message: state.message,
              onTryAgain: loadNotifications,
            );
          }

          if (state is NotificationLoaded) {
            return _buildNotificationContent(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationContent(NotificationLoaded state) {
    final notifications = state.notifications;

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => refreshNotifications(),
      color: context.colorScheme.primary,
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (_, index) {
          return _buildNotificationItem(notifications[index]);
        },
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: context.colorScheme.error,
        padding: context.paddingNormalRight,
        child: Icon(Icons.delete_outline, color: context.colorScheme.onError),
      ),
      onDismissed: (_) => deleteNotification(notification.id),
      child: Container(
        padding: context.paddingNormalAll,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.onSurface.withAlpha(50),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: context.paddingNormalAll,
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_outlined,
                size: IconSizeConstants.m,
                color: context.colorScheme.primary,
              ),
            ),
            context.spacingNormalWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          notification.title,
                          style: context.textTheme.bodyLarge,
                        ),
                      ),
                      Text(
                        formatDate(notification.date),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    notification.message,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(164),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomEmptyList(
      iconData: Icons.notifications_off_outlined,
      title: LocaleKeys.no_notifications.translate,
      description: LocaleKeys.no_notifications_description.translate,
    );
  }
}
