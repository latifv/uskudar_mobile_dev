import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/generate/bloc/qr_generate_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/generate/mixin/qr_generate_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/generate/widgets/qr_generate_form.dart';
import 'package:uskudar_mobile/presentation/shared/constants/image_asset_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class QrGenerateScreen extends StatefulWidget {
  const QrGenerateScreen({super.key});

  @override
  State<QrGenerateScreen> createState() => _QrGenerateScreenState();
}

final class _QrGenerateScreenState extends State<QrGenerateScreen>
    with QrGenerateMixin {
  double get _imageHeightFactor => .35;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocListener<QrGenerateBloc, QrGenerateState>(
            listener: blocListener,
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
      children: [
        _buildHeader(),
        context.spacingHighHeight,
        QrGenerateFormWidget(
          amountController: amountController,
          formKey: formKey,
        ),
        context.spacingMediumHeight,
        _buildGenerateButton(),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return PrimaryElevatedButton(
      onPressed: onGenerateQrPressed,
      text: LocaleKeys.qr_generate.translate,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          LocaleKeys.qr_generate.translate,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingNormalHeight,
        Text(
          LocaleKeys.qr_generate_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingNormalHeight,
        Image.asset(
          ImageAssetsConstants.qrGenerate,
          height: context.dynamicHeight(_imageHeightFactor),
        ),
      ],
    );
  }
}
