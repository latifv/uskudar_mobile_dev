import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/bloc/password_confirmation_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/mixin/password_confirmation_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/widgets/password_field.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/widgets/user_identity.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/logo_image.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class PasswordConfirmationScreen extends StatefulWidget {
  const PasswordConfirmationScreen({
    required this.identifier,
    super.key,
  });

  final String identifier;

  @override
  State<PasswordConfirmationScreen> createState() =>
      _PasswordConfirmationScreenState();
}

final class _PasswordConfirmationScreenState
    extends State<PasswordConfirmationScreen>
    with PasswordConfirmationMixin {
  @override
  void initState() {
    super.initState();
    identifier = widget.identifier;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<PasswordConfirmationBloc, PasswordConfirmationState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                body: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: context.paddingBase,
                      child: _buildBody(),
                    ),
                  ),
                ),
              ),
              if (state.status == PasswordConfirmationStatus.processing)
                const CustomProcessing(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        context.spacingMediumHeight,
        _buildPinField(),
        context.spacingMediumHeight,
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const LogoImage(heightFactor: .1),
        context.spacingMediumHeight,
        Text(
          LocaleKeys.password_confirmation_title.translate,
          style: context.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.password_confirmation_description.translate,
          style: context.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        context.spacingMediumHeight,
        _buildUserIdentity(),
      ],
    );
  }

  Widget _buildUserIdentity() {
    return UserIdentity(
      identifier: widget.identifier,
      onPressedForgetMe: onForgetMePressed,
    );
  }

  Widget _buildPinField() {
    return PasswordField(
      focusNode: passwordFocusNode,
      passwordController: passwordController,
      onChanged: onPasswordChanged,
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmitPressed,
      text: LocaleKeys.login.translate,
    );
  }
}
