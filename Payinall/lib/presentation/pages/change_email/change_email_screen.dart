import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/change_email/bloc/change_email_bloc.dart';
import 'package:payinall/presentation/pages/change_email/mixin/change_email_mixin.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

final class _ChangeEmailScreenState extends State<ChangeEmailScreen>
    with ChangeEmailMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<ChangeEmailBloc, ChangeEmailState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.change_email.translate),
            ),
            body: state.status == ChangeEmailStatus.success
                ? const Center(child: CustomLoading())
                : SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: context.paddingBase,
                        child: _buildBody(),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.dynamicHeight(0.3), child: _buildIcon()),
          SizedBox(
            height: context.dynamicHeight(0.45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                context.spacingNormalHeight,
                _buildEmailInput(),
                context.spacingHighHeight,
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.email_outlined,
        size: context.dynamicHeight(0.2),
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.change_email_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return CustomTextFormField(
      controller: newEmailController,
      focusNode: newEmailFocusNode,
      hintText: LocaleKeys.new_email_address.translate,
      keyboardType: TextInputType.emailAddress,
      validator: AppValidators.email,
      onFieldSubmitted: (_) => onSubmitPressed(),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.continue_button.translate,
    );
  }
}
