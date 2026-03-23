import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/campaign_merchant.dart';
import 'package:payinall/presentation/pages/merchant_detail/bloc/merchant_detail_bloc.dart';
import 'package:payinall/presentation/pages/merchant_detail/mixin/mechant_detail_mixin.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({
    required this.campaignMerchant,
    super.key,
  });

  final CampaignMerchant campaignMerchant;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

final class _MerchantDetailScreenState extends State<MerchantDetailScreen>
    with MerchantDetailMixin {
  @override
  String getImageUrl() => widget.campaignMerchant.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.campaignMerchant.merchant.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<MerchantDetailBloc, MerchantDetailState>(
            bloc: bloc,
            listener: blocListener,
            builder: (_, state) {
              // if (state.status == MerchantDetailStatus.processing) {
              //   return const CustomProcessing();
              // }
              return _buildBody();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: context.paddingNormalHorizontal,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ImageNetworkComponent(
                imageUrl: widget.campaignMerchant.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: context.paddingNormalAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget
                            .campaignMerchant
                            .merchant
                            .sectorArray
                            .isNotEmpty) ...[
                          Text(
                            LocaleKeys.sectors.translate,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          context.spacingLowHeight,
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget
                                .campaignMerchant
                                .merchant
                                .sectorArray
                                .where(
                                  (sector) => sector.name.isNotEmpty,
                                )
                                .map(
                                  (sector) => _buildSectorTag(
                                    context,
                                    sector.name,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.colorScheme.primary,
                          context.colorScheme.primary.withValues(
                            alpha: 0.5,
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '%${widget.campaignMerchant.cbAmount.toStringAsFixed(1)}',
                          style: context.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          LocaleKeys.cashback.translate,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              context.spacingNormalHeight,
              Text(
                LocaleKeys.campaign_details.translate,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                width: double.infinity,
                padding: context.paddingNormalAll,
                child: Text(
                  widget.campaignMerchant.content,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ),
              context.spacingNormalHeight,
            ],
          ),
        ),
        context.spacingNormalHeight,
        if (!userInfoManager.isMerchant) ...[
          PrimaryElevatedButton(
            width: context.dynamicWidth(.85),
            onPressed: createQrCode,
            text: LocaleKeys.generate_qr_code.translate,
          ),
        ],
      ],
    );
  }

  Widget _buildSectorTag(BuildContext context, String sectorName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        sectorName,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
