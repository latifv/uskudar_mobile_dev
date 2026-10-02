import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/international_transfer_result.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/bloc/international_money_transfer_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/mixin/international_transfer_confirmation_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/widgets/international_transfer_details_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class InternationalTransferConfirmationScreen extends StatefulWidget {
  const InternationalTransferConfirmationScreen({
    required this.transferResult,
    super.key,
  });

  final InternationalTransferResult transferResult;

  @override
  State<InternationalTransferConfirmationScreen> createState() =>
      _InternationalTransferConfirmationScreenState();
}

final class _InternationalTransferConfirmationScreenState
    extends State<InternationalTransferConfirmationScreen>
    with InternationalTransferConfirmationMixin {
  @override
  void initState() {
    super.initState();
    transferResult = widget.transferResult;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.transfer_confirmation.translate),
      ),
      body: BlocProvider.value(
        value: bloc,
        child:
            BlocConsumer<
              InternationalMoneyTransferBloc,
              InternationalMoneyTransferState
            >(
              listener: blocListener,
              builder: (context, state) {
                if (state.status ==
                    InternationalMoneyTransferStatus.confirming) {
                  return const Center(child: CustomLoading());
                }
                return _buildContent(context);
              },
            ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InternationalTransferDetailsCard(
                      transferResult: transferResult,
                    ),
                    context.spacingNormalHeight,
                    Text(
                      LocaleKeys.transfer_confirmation_description.translate,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            context.spacingNormalHeight,
            SizedBox(
              width: double.infinity,
              child: PrimaryElevatedButton(
                text: LocaleKeys.confirm.translate,
                onPressed: onConfirmPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
