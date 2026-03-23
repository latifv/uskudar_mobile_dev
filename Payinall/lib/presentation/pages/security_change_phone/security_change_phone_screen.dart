import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/security_change_phone/bloc/security_change_phone_bloc.dart';
import 'package:payinall/presentation/pages/security_change_phone/mixin/security_change_phone_mixin.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/tc_number_text_form_field.dart';

@RoutePage()
final class SecurityChangePhoneScreen extends StatefulWidget {
  const SecurityChangePhoneScreen({super.key});

  @override
  State<SecurityChangePhoneScreen> createState() =>
      _SecurityChangePhoneScreenState();
}

final class _SecurityChangePhoneScreenState
    extends State<SecurityChangePhoneScreen>
    with SecurityChangePhoneMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocListener<SecurityChangePhoneBloc, SecurityChangePhoneState>(
        listener: blocListener,
        child: Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: context.paddingBase,
                child: _buildBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.dynamicHeight(0.3), child: _buildIcon()),
        SizedBox(
          height: context.dynamicHeight(0.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildHeader(),
              context.spacingNormalHeight,
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildTcField()],
                ),
              ),
              context.spacingHighHeight,
              _buildSubmitButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.screen_lock_portrait,
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
          LocaleKeys.security_change_phone_title.translate,
          style: context.textTheme.headlineSmall,
        ),
        context.spacingLowHeight,
        Text(LocaleKeys.security_change_phone_description.translate),
      ],
    );
  }

  Widget _buildTcField() {
    return TcNumberTextFormField(tcNumberController: tcNumberController);
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmitPressed,
      text: LocaleKeys.continue_button.translate,
    );
  }
}
