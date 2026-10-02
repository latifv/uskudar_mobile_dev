import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/qr_operation/display/bloc/qr_display_bloc.dart';
import 'package:payinall/presentation/pages/qr_operation/display/mixin/qr_display_mixin.dart';
import 'package:payinall/presentation/pages/qr_operation/display/widgets/qr_display_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class QrDisplayScreen extends StatefulWidget {
  const QrDisplayScreen({
    required this.qrImage,
    required this.amount,
    super.key,
  });

  final Uint8List qrImage;
  final double amount;

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

final class _QrDisplayScreenState extends State<QrDisplayScreen>
    with QrDisplayMixin {
  @override
  void initState() {
    bloc = getIt<QrDisplayBloc>();

    onLoadQrData(qrImage: widget.qrImage, amount: widget.amount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: BlocBuilder<QrDisplayBloc, QrDisplayState>(
            builder: (context, state) {
              if (state is QrDisplayLoaded) {
                return Padding(
                  padding: context.paddingBase,
                  child: _buildBody(state),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(QrDisplayLoaded state) {
    return Column(
      children: [
        Expanded(
          child: QrDisplayCard(qrImage: state.qrImage, amount: state.amount),
        ),
        SurfaceElevatedButton(
          onPressed: onClosePressed,
          text: LocaleKeys.close.translate,
        ),
        context.spacingNormalHeight,
      ],
    );
  }
}
