import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/enums/bottom_page_enum.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    required this.router,
    this.navIconSize = IconSizeConstants.n * 1.15,
    super.key,
  });

  final TabsRouter router;
  final double navIconSize;

  @override
  Widget build(BuildContext context) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    return SafeArea(
      child: Padding(
        padding: context.paddingLowAll,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              index: BottomPageEnum.home.index,
              icon: FontAwesomeIcons.house,
              activeIcon: FontAwesomeIcons.house,
              label: LocaleKeys.home_title.translate,
            ),
            _buildNavItem(
              context,
              index: BottomPageEnum.transactions.index,
              icon: FontAwesomeIcons.chartSimple,
              activeIcon: FontAwesomeIcons.chartSimple,
              label: LocaleKeys.transactions_title.translate,
            ),
            if (!isMerchant)
              _buildNavItem(
                context,
                index: BottomPageEnum.payments.index,
                icon: FontAwesomeIcons.creditCard,
                activeIcon: FontAwesomeIcons.solidCreditCard,
                label: LocaleKeys.payments_title.translate,
              ),
            _buildNavItem(
              context,
              index: isMerchant
                  ? BottomPageEnum.payments.index
                  : BottomPageEnum.international.index,
              icon: FontAwesomeIcons.earthAmericas,
              activeIcon: FontAwesomeIcons.earthAmericas,
              label: LocaleKeys.abroad.translate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required FaIconData icon,
    required String label,
    FaIconData? activeIcon,
  }) {
    final isSelected = router.activeIndex == index;
    return InkWell(
      onTap: () {
        router.setActiveIndex(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            isSelected && activeIcon != null ? activeIcon : icon,
            size: navIconSize,
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          context.spacingLowHeight,
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? context.colorScheme.primary
                  : context.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
