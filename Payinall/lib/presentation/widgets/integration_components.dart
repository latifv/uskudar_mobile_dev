import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

abstract final class AlisverislioColors {
  static const primary = Color(0xFF4F2BD8);
  static const primaryDark = Color(0xFF2F139A);
  static const lilac = Color(0xFFF0ECFF);
  static const background = Color(0xFFF8F7FC);
  static const Color surface = Colors.white;
  static const textPrimary = Color(0xFF17151C);
  static const textSecondary = Color(0xFF918E98);
  static const divider = Color(0xFFE7E4EC);
  static const cashback = Color(0xFF43B552);
  static const cashbackBackground = Color(0xFFEAF7EC);
  static const type = Color(0xFFC96F00);
  static const typeBackground = Color(0xFFFFF0DA);
}

String integrationBrandDisplayName(String name) {
  return name.replaceFirst(RegExp(r'\s+ER$', caseSensitive: false), '').trim();
}

final class IntegrationSurface extends StatelessWidget {
  const IntegrationSurface({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.showBorder = true,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    return Material(
      color: backgroundColor ?? AlisverislioColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: showBorder
            ? BorderSide(
                color: AlisverislioColors.divider.withAlpha(180),
              )
            : BorderSide.none,
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
    final resolvedColor = color ?? AlisverislioColors.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color == null
            ? AlisverislioColors.lilac
            : resolvedColor.withAlpha(24),
        borderRadius: BorderRadius.circular(size / 2),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ImageNetworkComponent(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}

final class CashbackBadge extends StatelessWidget {
  const CashbackBadge({
    required this.rate,
    this.roundToWhole = false,
    super.key,
  });

  final double rate;
  final bool roundToWhole;

  @override
  Widget build(BuildContext context) {
    final percentage = rate * 100;
    final value = roundToWhole
        ? percentage.round().toString()
        : percentage == percentage.roundToDouble()
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AlisverislioColors.cashbackBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '%$value Nakit İade',
        maxLines: 1,
        style: context.textTheme.labelSmall?.copyWith(
          color: AlisverislioColors.cashback,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

final class AlisverislioStickyCta extends StatelessWidget {
  const AlisverislioStickyCta({
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.icon = Icons.card_giftcard_rounded,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AlisverislioColors.primary,
              AlisverislioColors.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x334F2BD8),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    if (isLoading)
                      const SizedBox.square(
                        dimension: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    else
                      Icon(icon, size: 30, color: Colors.white),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withAlpha(220),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class AlisverislioStateView extends StatelessWidget {
  const AlisverislioStateView({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.isError = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final accent = isError
        ? const Color(0xFFD04B45)
        : AlisverislioColors.primary;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntegrationIconBox(icon: icon, color: accent, size: 56),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium?.copyWith(
              color: AlisverislioColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: AlisverislioColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: AlisverislioColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(156, 44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded, size: 19),
              label: Text(actionLabel!),
            ),
          ],
        ],
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
