import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/request_money.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

final class MoneyRequestCard extends StatelessWidget {
  const MoneyRequestCard({
    required this.request,
    required this.onApprove,
    required this.onReject,
    required this.onDelete,
    required this.isIncoming,
    super.key,
  });

  final RequestMoney request;
  final void Function(RequestMoney) onApprove;
  final void Function(RequestMoney) onReject;
  final void Function(RequestMoney) onDelete;
  final bool isIncoming;

  double get _avatarRadius => 24;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingNormalVertical,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withAlpha(50),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          _buildDivider(context),
          _buildContent(context),
          if (isIncoming) _buildActions(context),
          if (!isIncoming) _buildDeleteAction(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll,
      child: Row(
        children: [
          _buildAvatar(context),
          context.spacingNormalWidth,
          Expanded(
            child: Text(
              isIncoming ? request.fromUserName : request.toUserName,
              style: context.textTheme.displayLarge,
            ),
          ),
          _buildAmount(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final name = isIncoming ? request.fromUserName : request.toUserName;
    return CircleAvatar(
      radius: _avatarRadius,
      backgroundColor: context.colorScheme.primary.withAlpha(40),
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: context.textTheme.displayLarge?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${request.amount} TL',
          style: context.textTheme.titleMedium?.copyWith(
            color: isIncoming ? Colors.green.shade700 : Colors.blue.shade700,
          ),
        ),
        context.spacingLowHeight,
        Text(
          _formatDateTime(request.createdDate),
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(80),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('HH:mm');
    return '${dateFormatter.format(date)} ${timeFormatter.format(date)}';
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colorScheme.onSurface.withAlpha(100),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: context.paddingNormalHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isIncoming
                    ? Icons.call_received_rounded
                    : Icons.call_made_rounded,
                size: IconSizeConstants.s,
                color: isIncoming
                    ? Colors.green.shade700
                    : Colors.blue.shade700,
              ),
              context.spacingLowWidth,
              Text(
                isIncoming
                    ? LocaleKeys.incoming_request.translate
                    : LocaleKeys.outgoing_request.translate,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isIncoming
                      ? Colors.green.shade700
                      : Colors.blue.shade700,
                ),
              ),
              const Spacer(),
              _buildStatusChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return Container(
      margin: context.paddingLowVertical,
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: isIncoming ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Text(
        LocaleKeys.waiting_for_approval.translate,
        style: context.textTheme.labelSmall?.copyWith(
          color: isIncoming ? Colors.green.shade700 : Colors.orange.shade800,
        ),
      ),
    );
  }

  // Widget _buildDescription(BuildContext context) {
  //   return Container(
  //     margin: context.paddingLowVertical,
  //     padding: context.paddingLowAll,
  //     decoration: BoxDecoration(
  //       color: context.colorScheme.onSurface.withAlpha(10),
  //       borderRadius: context.borderRadiusLowAll,
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.description_outlined,
  //           size: IconSizeConstants.s,
  //           color: context.colorScheme.onSurface,
  //         ),
  //         context.spacingLowWidth,
  //         Expanded(
  //           child: Text(
  //             request.description,
  //             style: context.textTheme.bodyMedium?.copyWith(
  //               color: context.colorScheme.onSurface,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll + context.paddingLowHorizontal,
      child: Row(
        children: [
          Expanded(
            child: SurfaceElevatedButton(
              onPressed: () => onReject(request),
              text: LocaleKeys.reject.translate,
            ),
          ),
          context.spacingNormalWidth,
          Expanded(
            child: PrimaryElevatedButton(
              onPressed: () => onApprove(request),
              text: LocaleKeys.approve.translate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteAction(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll + context.paddingLowHorizontal,
      child: SizedBox(
        width: double.infinity,
        child: SurfaceElevatedButton(
          onPressed: () => onDelete(request),
          text: LocaleKeys.delete.translate,
          textColor: Colors.red.shade700,
        ),
      ),
    );
  }
}
