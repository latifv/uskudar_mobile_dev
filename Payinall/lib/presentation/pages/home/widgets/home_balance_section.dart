import 'package:flutter/material.dart';
import 'package:payinall/core/constants/app_constants.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class HomeBalanceSection extends StatefulWidget {
  const HomeBalanceSection({
    required this.balance,
    required this.blockBalance,
    required this.walletAddress,
    required this.onCopyUserNumberPressed,
    required this.onLoadMoneyPressed,
    required this.isMerchant,
    super.key,
  });
  final double balance;
  final double blockBalance;
  final String walletAddress;
  final VoidCallback onCopyUserNumberPressed;
  final VoidCallback onLoadMoneyPressed;
  final bool isMerchant;
  @override
  State<HomeBalanceSection> createState() => _HomeBalanceSectionState();
}

final class _HomeBalanceSectionState extends State<HomeBalanceSection> {
  bool _isBalanceVisible = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: context.paddingNormalAll + context.paddingLowHorizontal,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
              colors: [
                Color(0xFF3036B2),
                Color(0xFF1AC7FF),
              ],
            ),
            borderRadius: context.borderRadiusNormalAll,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    LocaleKeys.balance.translate,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade100,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isBalanceVisible = !_isBalanceVisible;
                      });
                    },
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                      size: IconSizeConstants.m,
                    ),
                  ),
                ],
              ),
              context.spacingLowHeight,
              Text(
                _isBalanceVisible
                    ? '${widget.balance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}${AppConstants.currencySymbol}'
                    : '*****,**${AppConstants.currencySymbol}',
                style: context.textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              context.spacingLowHeight,
              if (widget.blockBalance > 0)
                Row(
                  children: [
                    Text(
                      LocaleKeys.block_balance.translate,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade100,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _isBalanceVisible
                            ? '${widget.blockBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}${AppConstants.currencySymbol}'
                            : '*****,**${AppConstants.currencySymbol}',
                        style: context.textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              context.spacingLowHeight,
              Row(
                children: [
                  Text(
                    widget.walletAddress,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  context.spacingLowWidth,
                  InkWell(
                    onTap: widget.onCopyUserNumberPressed,
                    child: const Icon(
                      Icons.copy_outlined,
                      size: IconSizeConstants.s,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (!widget.isMerchant) ...[
                    InkWell(
                      onTap: widget.onLoadMoneyPressed,
                      child: Container(
                        padding:
                            context.paddingLowAll +
                            context.paddingNormalHorizontal,
                        decoration: BoxDecoration(
                          color: const Color(0xFF009F48),
                          borderRadius: context.borderRadiusNormalAll,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              LocaleKeys.money_load.translate,
                              style: context.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            context.spacingLowWidth,
                            const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: IconSizeConstants.n,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
