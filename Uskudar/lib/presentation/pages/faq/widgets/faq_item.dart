import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payinall/domain/entities/help.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class FaqItem extends StatelessWidget {
  const FaqItem({
    required this.help,
    required this.onTap,
    required this.isExpanded,
    super.key,
  });

  final Help help;
  final VoidCallback onTap;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: context.paddingLowAll,
      color: context.colorScheme.surface,
      child: ExpansionTile(
        initiallyExpanded: isExpanded,
        onExpansionChanged: (_) => onTap(),
        title: Text(help.title, style: context.textTheme.bodyMedium),
        iconColor: context.colorScheme.onSurface.withAlpha(164),
        collapsedIconColor: context.colorScheme.onSurface.withAlpha(164),
        childrenPadding:
            context.paddingMediumHorizontal + context.paddingNormalBottom,
        shape: RoundedRectangleBorder(
          borderRadius: context.borderRadiusLowBottom,
        ),
        children: [Html(data: help.content)],
      ),
    );
  }
}
