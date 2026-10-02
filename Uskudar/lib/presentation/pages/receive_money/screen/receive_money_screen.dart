import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_state.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/mixin/receive_money_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

final class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen>
    with ReceiveMoneyMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.receive_money.translate),
      ),
      body: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<ReceiveMoneyBloc, ReceiveMoneyState>(
          listener: blocListener,
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: context.paddingNormalAll,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: referenceController,
                        focusNode: referenceFocusNode,
                        hintText: LocaleKeys.enter_reference_number.translate,
                        labelText: LocaleKeys.reference_number.translate,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => onSubmitPressed(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return LocaleKeys
                                .reference_number_required.translate;
                          }
                          return null;
                        },
                      ),
                      context.spacingMediumHeight,
                      SizedBox(
                        width: double.infinity,
                        child: state.status == ReceiveMoneyStatus.loading
                            ? const Center(child: CustomLoading())
                            : PrimaryElevatedButton(
                                text: LocaleKeys.receive_transfer.translate,
                                onPressed: onSubmitPressed,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
