import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:payinall/presentation/pages/splash/mixin/splash_mixin.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/logo_image.dart';

@RoutePage()
final class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends State<SplashScreen> with SplashMixin {
  final _logoWidthFactor = .6;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc..add(const SplashInitServices()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: blocListener,
        child: Scaffold(
          backgroundColor: context.colorScheme.primary,
          body: Center(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LogoImage(
          widthFactor: _logoWidthFactor,
          imagePath: IconAssetsConstants.splash,
        ),
        context.spacingMediumHeight,
        CustomLoading(
          color: context.colorScheme.onPrimary,
        ),
      ],
    );
  }
}
