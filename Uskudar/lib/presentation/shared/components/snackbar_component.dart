import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class SnackBarComponent {
  const SnackBarComponent._();

  static void showSnackBar({
    required BuildContext context,
    required String? message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }

  static void showSuccessSnackBar({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.green,
      duration: duration,
      action: action,
    );
  }

  static void showErrorSnackBar({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showSnackBar(
      context: context,
      message: message,
      backgroundColor: context.colorScheme.error,
      duration: duration,
      action: action,
    );
  }

  static void showWarningSnackBar({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.orange,
      duration: duration,
      action: action,
    );
  }

  static void showInfoSnackBar({
    required BuildContext context,
    required String? message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
  }) {
    if (!context.mounted || message == null || message.isEmpty) {
      return;
    }

    showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.blue,
      duration: duration,
      action: action,
    );
  }
}
