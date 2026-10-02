import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/utils/app_utils.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/campaign_qr_code/bloc/campaign_qr_code_bloc.dart';
import 'package:payinall/presentation/pages/campaign_qr_code/mixin/campaign_qr_code_mixin.dart';
import 'package:payinall/presentation/pages/campaign_qr_code/widgets/campaign_qr_code_card.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/constants/image_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';

@RoutePage()
final class CampaignQrCodeScreen extends StatefulWidget {
  const CampaignQrCodeScreen({
    required this.qrCode,
    required this.imageUrl,
    super.key,
  });

  final String qrCode;
  final String imageUrl;

  @override
  State<CampaignQrCodeScreen> createState() => _CampaignQrCodeScreenState();
}

final class _CampaignQrCodeScreenState extends State<CampaignQrCodeScreen>
    with CampaignQrCodeMixin {
  @override
  void initState() {
    bloc = getIt<CampaignQrCodeBloc>();
    onLoadQrData(qrCode: widget.qrCode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocBuilder<CampaignQrCodeBloc, CampaignQrCodeState>(
            builder: (context, state) {
              if (state is CampaignQrCodeLoaded) {
                return Padding(
                  padding: context.paddingBaseLow,
                  child: _buildBody(state),
                );
              } else if (state is CampaignQrCodeRegenerating) {
                return _buildRegeneratingView();
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CampaignQrCodeLoaded state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: context.dynamicHeight(.135),
          decoration: BoxDecoration(
            borderRadius: context.borderRadiusLowAll,
          ),
          child: ClipRRect(
            borderRadius: context.borderRadiusLowAll,
            child: ImageNetworkComponent(
              imageUrl: widget.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        context.spacingNormalHeight,
        Image.asset(
          ImageAssetsConstants.poweredIWallet,
          height: context.dynamicHeight(.05),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.please_specify_iwallet_payment.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.tell_cashier_code_shopping.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingLowHeight,
        Container(
          width: context.dynamicWidth(.8),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: context.borderRadiusNormalAll,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  state.qrCode,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(164),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              context.spacingLowWidth,
              IconButton(
                onPressed: () => AppUtils.copyToClipboard(state.qrCode),
                icon: const Icon(
                  Icons.copy,
                  size: IconSizeConstants.n,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.or.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: CampaignQrCodeCard(
            qrCode: state.qrCode,
            remainingTime: formatTime(state.remainingSeconds),
          ),
        ),
      ],
    );
  }

  Widget _buildRegeneratingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.qr_code_regenerating.translate,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
