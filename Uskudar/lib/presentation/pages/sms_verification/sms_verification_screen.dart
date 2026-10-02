import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/sms_verification_type.dart';
import 'package:uskudar_mobile/presentation/pages/sms_verification/bloc/sms_verification_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/sms_verification/mixin/sms_verification_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/sms_verification/widgets/pin_code_field.dart';
import 'package:uskudar_mobile/presentation/pages/sms_verification/widgets/timer_section.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_button.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class SmsVerificationScreen extends StatefulWidget {
  const SmsVerificationScreen({
    required this.phoneNumber,
    required this.smsVerificationType,
    required this.processCode,
    this.newPhoneNumber,
    this.identityNumber,
    this.securityQuestionAnswer,
    this.rememberMe,

    super.key,
  });

  final String phoneNumber;
  final String? newPhoneNumber;
  final String? identityNumber;
  final String? securityQuestionAnswer;
  final int smsVerificationType;
  final String processCode;
  final bool? rememberMe;
  @override
  State<SmsVerificationScreen> createState() => _SmsVerificationScreenState();
}

final class _SmsVerificationScreenState extends State<SmsVerificationScreen>
    with VerificationMixin {
  @override
  void initState() {
    phoneNumber = widget.phoneNumber;
    smsVerificationType = widget.smsVerificationType.toSmsVerificationType();
    processCode = widget.processCode;
    rememberMe = widget.rememberMe;
    newPhoneNumber = widget.newPhoneNumber;
    identityNumber = widget.identityNumber;
    securityQuestionAnswer = widget.securityQuestionAnswer;

    bloc = getIt<SmsVerificationBloc>();
    Future.microtask(
      () => bloc.add(SmsVerificationTimerStart(processCode: processCode)),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: BlocConsumer<SmsVerificationBloc, SmsVerificationState>(
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
                body: state.status == SmsVerificationBlocStatus.loading
                    ? const Center(child: CustomLoading())
                    : SingleChildScrollView(
                        padding: context.paddingBase,
                        child: _buildBody(),
                      ),
              ),
              if (state.status == SmsVerificationBlocStatus.processing)
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
        _buildPinCodeField(),
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
          LocaleKeys.verification_title.translate,
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
                text: LocaleKeys.verification_description.translate,
              ),
              TextSpan(
                text:
                    smsVerificationType == SmsVerificationType.changePhoneNumber
                    ? ' $newPhoneNumber'
                    : ' $phoneNumber',
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
    return StreamBuilder<TimerState>(
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

  Widget _buildPinCodeField() {
    return PinCodeField(
      focusNode: focusNode,
      onChanged: onPinChanged,
      pinController: pinController,
    );
  }

  Widget _buildResendCode() {
    if (smsVerificationType == SmsVerificationType.merchantLogin) {
      return const SizedBox.shrink();
    }
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
