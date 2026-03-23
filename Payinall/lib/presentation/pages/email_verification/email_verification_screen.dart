import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/email_verification_type.dart';
import 'package:payinall/presentation/pages/email_verification/bloc/email_verification_bloc.dart';
import 'package:payinall/presentation/pages/email_verification/mixin/email_verification_mixin.dart';
import 'package:payinall/presentation/pages/sms_verification/widgets/pin_code_field.dart';
import 'package:payinall/presentation/pages/sms_verification/widgets/timer_section.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_processing.dart';
import 'package:payinall/presentation/widgets/custom_text_button.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({
    required this.emailVerificationType,
    required this.processCode,
    this.email,
    this.newEmail,
    super.key,
  });

  final String? email;
  final String? newEmail;
  final int emailVerificationType;
  final String processCode;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

final class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with EmailVerificationMixin {
  @override
  void initState() {
    email = widget.email;
    newEmail = widget.newEmail;
    emailVerificationType =
        widget.emailVerificationType.toEmailVerificationType();
    processCode = widget.processCode;

    bloc = getIt<EmailVerificationBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.add(EmailVerificationTimerStart(processCode: processCode));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
        listener: blocListener,
        builder: (_, state) {
          return Stack(
            children: [
              Scaffold(
                appBar: CustomAppBar(
                  title: Text(
                    LocaleKeys.verification.translate,
                  ),
                ),
                body: state.status == EmailVerificationBlocStatus.loading
                    ? const Center(child: CustomLoading())
                    : SingleChildScrollView(
                        padding: context.paddingBase,
                        child: _buildBody(),
                      ),
              ),
              if (state.status == EmailVerificationBlocStatus.processing)
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
        SizedBox(
          height: context.dynamicHeight(0.35),
          child: _buildTimerSection(),
        ),
        context.spacingNormalHeight,
        _buildHeader(),
        context.spacingMediumHeight,
        _buildCodeField(),
        context.spacingMediumHeight,
        _buildVerifyButton(),
        context.spacingLowHeight,
        _buildResendCode(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.email_verification_title.translate,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        context.spacingLowHeight,
        RichText(
          text: TextSpan(
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            children: [
              TextSpan(
                text: LocaleKeys.email_verification_description.translate,
              ),
              TextSpan(
                text: emailVerificationType == EmailVerificationType.emailChange
                    ? ' $newEmail'
                    : ' $email',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection() {
    return StreamBuilder<EmailTimerState>(
      stream: bloc.timerStream,
      initialData: bloc.timerState,
      builder: (context, snapshot) {
        final remainingTime = snapshot.data?.remainingTime;
        final timerDuration = bloc.timerDuration;
        return TimerSection(
          remainingTime: remainingTime ?? 0,
          timerDuration: timerDuration,
        );
      },
    );
  }

  Widget _buildCodeField() {
    return PinCodeField(
      focusNode: focusNode,
      onChanged: onCodeChanged,
      pinController: codeController,
    );
  }

  Widget _buildResendCode() {
    return CustomTextButton(
      onPressed: onResendPressed,
      text: LocaleKeys.verification_resend_code.translate,
      textStyle: context.textTheme.bodyLarge?.copyWith(
        decorationColor: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return PrimaryElevatedButton(
      onPressed: onVerifyPressed,
      text: LocaleKeys.verify.translate,
    );
  }
}
