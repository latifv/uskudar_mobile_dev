import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transfer/bloc/metropol_transfer_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transfer/mixin/metropol_transfer_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transfer/widgets/transfer_result_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class MetropolTransferScreen extends StatefulWidget {
  const MetropolTransferScreen({super.key});

  @override
  State<MetropolTransferScreen> createState() => _MetropolTransferScreenState();
}

final class _MetropolTransferScreenState extends State<MetropolTransferScreen>
    with MetropolTransferMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.qr_pay.translate),
      ),
      body: BlocConsumer<MetropolTransferBloc, MetropolTransferState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCodeTypeSelector(context),
                  const SizedBox(height: 12),
                  _buildCodeInput(context),
                  const SizedBox(height: 16),
                  _buildSubmitButton(state),
                  if (state.status == MetropolTransferStatus.transferReady &&
                      state.transferResult != null) ...[
                    const SizedBox(height: 12),
                    TransferResultCard(
                      result: state.transferResult!,
                      onConfirm: () => onConfirmTransfer(
                        state.transferResult!.transactionId.toString(),
                      ),
                    ),
                  ],
                  if (state.status == MetropolTransferStatus.loading ||
                      state.status == MetropolTransferStatus.confirming) ...[
                    context.spacingNormalHeight,
                    const Center(child: CustomLoading()),
                  ],
                  const SizedBox(height: 20),
                  SurfaceElevatedButton(
                    onPressed: onDrawBack,
                    text: LocaleKeys.transfer_to_wallet.translate,
                    color: context.colorScheme.error,
                    textColor: context.colorScheme.error,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCodeTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.code_type.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text(LocaleKeys.qr_code.translate),
                icon: const Icon(Icons.qr_code_rounded),
              ),
              ButtonSegment(
                value: 1,
                label: Text(LocaleKeys.short_code.translate),
                icon: const Icon(Icons.sms_rounded),
              ),
            ],
            selected: {selectedCodeType},
            onSelectionChanged: (value) => onCodeTypeChanged(value.first),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput(BuildContext context) {
    return CustomTextFormField(
      controller: codeController,
      hintText: selectedCodeType == 0
          ? LocaleKeys.enter_qr_or_scan.translate
          : LocaleKeys.enter_short_code.translate,
      labelText: selectedCodeType == 0
          ? LocaleKeys.qr_code.translate
          : LocaleKeys.short_code.translate,
      prefixIcon: Icon(
        selectedCodeType == 0
            ? Icons.qr_code_scanner_rounded
            : Icons.sms_rounded,
      ),
      suffixIcon: selectedCodeType == 0
          ? IconButton(
              onPressed: onQrScanPressed,
              icon: const Icon(Icons.camera_alt_rounded),
            )
          : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return selectedCodeType == 0
              ? LocaleKeys.enter_qr_code_validation.translate
              : LocaleKeys.enter_short_code_validation.translate;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(MetropolTransferState state) {
    final isLoading =
        state.status == MetropolTransferStatus.loading ||
        state.status == MetropolTransferStatus.confirming;

    return PrimaryElevatedButton(
      onPressed: isLoading ? () {} : onSubmitTransfer,
      text: LocaleKeys.send.translate,
    );
  }
}
