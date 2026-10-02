import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/auth/register/bloc/register_bloc.dart';
import 'package:payinall/presentation/pages/auth/register/mixin/register_mixin.dart';
import 'package:payinall/presentation/shared/constants/image_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_processing.dart';
import 'package:payinall/presentation/widgets/logo_image.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/register_phone_number_text_form_field.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

final class _RegisterScreenState extends State<RegisterScreen>
    with RegisterMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                body: _buildBody(),
              ),
              if (state.status == RegisterBlocStatus.processing)
                const CustomProcessing(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildBackgroundImage(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.325, 0.45, 1.0],
                colors: [
                  context.colorScheme.surface.withValues(alpha: 0),
                  context.colorScheme.surface.withValues(alpha: 0.75),
                  context.colorScheme.surface.withValues(alpha: 0.9),
                  context.colorScheme.surface,
                  context.colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: context.paddingBase,
                child: _buildContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssetsConstants.register),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.dynamicHeight(0.3), child: _buildLogo()),
        _buildHeader(),
        context.spacingNormalHeight,
        _buildForm(),
        context.spacingMediumHeight,
        _buildContinueButton(),
        context.spacingNormalHeight,
        _buildLoginRedirect(),
      ],
    );
  }

  Widget _buildLogo() {
    return const Center(
      child: LogoImage(
        heightFactor: 0.065,
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.register_title.translate,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.register_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          RegisterPhoneNumberTextFormField(
            phoneNumberController: phoneNumberController,
            phoneNumberFocusNode: phoneNumberFocusNode,
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return PrimaryElevatedButton(
      onPressed: onRegisterPressed,
      text: LocaleKeys.continue_button.translate,
    );
  }

  Widget _buildLoginRedirect() {
    return SurfaceElevatedButton(
      onPressed: onLoginPressed,
      text: LocaleKeys.already_have_account.translate,
    );
  }
}
