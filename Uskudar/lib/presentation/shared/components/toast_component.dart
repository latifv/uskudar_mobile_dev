import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class ToastComponent {
  const ToastComponent._();
  static const Duration _defaultDuration = Duration(seconds: 2);

  static void showBottomToastMessage({
    required BuildContext context,
    String? message,
    Duration? duration,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showToast(
      message,
      position: StyledToastPosition.bottom,
      context: context,
      animation: StyledToastAnimation.size,
      duration: duration ?? _defaultDuration,
    );
  }

  static void showTopToastMessage({
    required BuildContext context,
    String? message,
    Duration? duration,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showToast(
      message,
      position: StyledToastPosition.top,
      context: context,
      animation: StyledToastAnimation.size,
      duration: duration ?? _defaultDuration,
    );
  }

  static void showCustomToast({
    required BuildContext context,
    String? message,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showToastWidget(
      _CustomToastWidget(message: message, onClose: dismissAllToast),
      context: context,
      animation: StyledToastAnimation.fade,
      position: StyledToastPosition.top,
      duration: Duration.zero,
      isIgnoring: false,
    );
  }

  static void showSuccessToast({
    required BuildContext context,
    String? message,
    Duration? duration,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showToast(
      message,
      position: StyledToastPosition.top,
      context: context,
      backgroundColor: Colors.green,
      animation: StyledToastAnimation.size,
      duration: duration ?? _defaultDuration,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    String? message,
    Duration? duration,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showToast(
      message,
      position: StyledToastPosition.top,
      context: context,
      backgroundColor: context.colorScheme.error,
      animation: StyledToastAnimation.fade,
      duration: duration ?? _defaultDuration,
    );
  }
}

final class _CustomToastWidget extends StatelessWidget {
  const _CustomToastWidget({required this.message, required this.onClose});
  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingNormalAll,
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: context.colorScheme.surface),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
