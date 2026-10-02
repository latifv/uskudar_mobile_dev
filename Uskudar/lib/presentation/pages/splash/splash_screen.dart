import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/splash/mixin/splash_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/logo_image.dart';

@RoutePage()
final class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final class _SplashScreenState extends State<SplashScreen> with SplashMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc..add(const SplashInitServices()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: blocListener,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox.expand(child: _buildBody()),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LogoImage(heightFactor: .16, widthFactor: .94),
            const SizedBox(height: 28),
            CustomLoading(color: context.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
