import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/campaign_merchant.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CampaignListItem extends StatelessWidget {
  const CampaignListItem({
    required this.campaignMerchant,
    required this.onTap,
    super.key,
  });

  final CampaignMerchant campaignMerchant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: context.borderRadiusNormalAll,
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: context.borderRadiusNormalAll,
          child: Padding(
            padding: context.paddingLowAll,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ImageNetworkComponent(
                    imageUrl: campaignMerchant.merchant.logo,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaignMerchant.merchant.name,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      context.spacingLowHeight,
                      Text(
                        _getSubtitle(campaignMerchant.content),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      context.spacingLowHeight,
                      if (campaignMerchant.merchant.sectorArray.isNotEmpty)
                        Text(
                          campaignMerchant.merchant.sectorArray
                              .map((sector) => sector.name)
                              .join(', '),
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  flex: 3,
                  child: Text(
                    '%${campaignMerchant.cbAmount.toStringAsFixed(1)}',
                    style: context.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSubtitle(String content) {
    if (content.length <= 100) {
      return content;
    }
    return '${content.substring(0, 100)}...';
  }
}
