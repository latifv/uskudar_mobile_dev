import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_gift_transfer/bloc/metropol_gift_transfer_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_gift_transfer/mixin/metropol_gift_transfer_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/price_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class MetropolGiftTransferScreen extends StatefulWidget {
  const MetropolGiftTransferScreen({super.key});

  @override
  State<MetropolGiftTransferScreen> createState() =>
      _MetropolGiftTransferScreenState();
}

final class _MetropolGiftTransferScreenState
    extends State<MetropolGiftTransferScreen>
    with MetropolGiftTransferMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.clothing_balance_top_up.translate),
      ),
      body: BlocConsumer<MetropolGiftTransferBloc, MetropolGiftTransferState>(
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
                  Text(
                    LocaleKeys.gift_transfer_description.translate,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PriceTextFormField(
                    priceController: amountController,
                  ),
                  const SizedBox(height: 16),
                  PrimaryElevatedButton(
                    onPressed:
                        state.status == MetropolGiftTransferStatus.loading
                        ? () {}
                        : onSubmitTransfer,
                    text: LocaleKeys.send.translate,
                  ),
                  if (state.status == MetropolGiftTransferStatus.loading) ...[
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
}
