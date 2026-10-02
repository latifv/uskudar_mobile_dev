import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/address_preview/bloc/address_preview_bloc.dart';
import 'package:payinall/presentation/pages/address_preview/mixin/address_preview_mixin.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_processing.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class AddressPreviewScreen extends StatefulWidget {
  const AddressPreviewScreen({super.key});

  @override
  State<AddressPreviewScreen> createState() => _AddressPreviewScreenState();
}

final class _AddressPreviewScreenState extends State<AddressPreviewScreen>
    with AddressPreviewMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<AddressPreviewBloc, AddressPreviewState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(LocaleKeys.address_preview_title.translate),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: context.paddingBase,
                    child: _buildBody(state),
                  ),
                ),
              ),
              if (state.status == AddressPreviewStatus.processing)
                const CustomProcessing(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(AddressPreviewState state) {
    if (state.status == AddressPreviewStatus.loading) {
      return const Center(child: CustomLoading());
    }

    if (state.status == AddressPreviewStatus.error) {
      return ErrorTryAgain(
        message: state.message ?? LocaleKeys.unknown_error.translate,
        onTryAgain: onRetryPressed,
      );
    }

    if (state.status == AddressPreviewStatus.loaded ||
        state.status == AddressPreviewStatus.processing) {
      return _buildContent(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildContent(AddressPreviewState state) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              kToolbarHeight -
              32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoText(),
                context.spacingMediumHeight,
                _buildAddressCard(state),
              ],
            ),
            _buildActionButtons(),
            context.spacingLowHeight,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Text(
      LocaleKeys.address_preview_instruction.translate,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAddressCard(AddressPreviewState state) {
    final addressInfo = state.userAddressInformation;
    if (addressInfo == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: context.paddingMediumAll,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusNormalAll,
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: context.colorScheme.primary,
                size: IconSizeConstants.l,
              ),
              context.spacingLowWidth,
              Text(
                LocaleKeys.address_info.translate,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          context.spacingMediumHeight,
          _buildAddressInfoRow(
            '${LocaleKeys.address_number.translate}:',
            addressInfo.addressNumber,
          ),
          context.spacingNormalHeight,
          _buildAddressInfoRow(
            '${LocaleKeys.address.translate}:',
            addressInfo.address,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        context.spacingLowHeight,
        Container(
          width: double.infinity,
          padding: context.paddingNormalAll,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withValues(alpha: 0.3),
            borderRadius: context.borderRadiusLowAll,
          ),
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryElevatedButton(
          onPressed: onApprovePressed,
          text: LocaleKeys.approve.translate,
        ),
        context.spacingNormalHeight,
        SurfaceElevatedButton(
          onPressed: onDifferentAddressPressed,
          text: LocaleKeys.different_address.translate,
        ),
      ],
    );
  }
}
