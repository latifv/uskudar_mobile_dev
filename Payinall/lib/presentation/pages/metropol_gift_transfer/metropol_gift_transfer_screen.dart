import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/metropol_gift_transfer/bloc/metropol_gift_transfer_bloc.dart';
import 'package:payinall/presentation/pages/metropol_gift_transfer/mixin/metropol_gift_transfer_mixin.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

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
            padding: context.paddingBaseLow,
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
                  context.spacingNormalHeight,
                  PriceTextFormField(
                    priceController: amountController,
                  ),
                  context.spacingNormalHeight,
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
                  context.spacingMediumHeight,
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
