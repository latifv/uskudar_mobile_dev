import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class IntegrationSurface extends StatelessWidget {
  const IntegrationSurface({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: backgroundColor ?? context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusLowAll,
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withAlpha(120),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

final class IntegrationIconBox extends StatelessWidget {
  const IntegrationIconBox({
    required this.icon,
    this.color,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? context.colorScheme.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolvedColor.withAlpha(24),
        borderRadius: context.borderRadiusLowAll,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 22, color: resolvedColor),
    );
  }
}

final class IntegrationBrandLogo extends StatelessWidget {
  const IntegrationBrandLogo({
    required this.imageUrl,
    this.size = 64,
    super.key,
  });

  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLowest,
        borderRadius: context.borderRadiusLowAll,
      ),
      child: ImageNetworkComponent(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}

final class CashbackBadge extends StatelessWidget {
  const CashbackBadge({required this.rate, super.key});

  final double rate;

  @override
  Widget build(BuildContext context) {
    final percentage = rate * 100;
    final value = percentage == percentage.roundToDouble()
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withAlpha(24),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Text(
        '%$value Nakit İade',
        maxLines: 1,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

final class IntegrationActionCard extends StatelessWidget {
  const IntegrationActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IntegrationIconBox(icon: icon, color: color, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
