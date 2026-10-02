import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({
    this.title,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.leading,
    super.key,
  });

  final Widget? title;
  final double elevation;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: title,
      scrolledUnderElevation: elevation,
      elevation: elevation,
      shadowColor: context.theme.colorScheme.onPrimary,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
