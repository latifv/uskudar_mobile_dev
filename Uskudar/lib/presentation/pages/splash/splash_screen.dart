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
          backgroundColor: const Color(0xFFF7FAFC),
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFF0F7FB)],
              ),
            ),
            child: SizedBox.expand(child: _buildBody()),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Positioned(
          top: -130,
          right: -120,
          child: Container(
            width: 320,
            height: 320,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x0D0D5789),
            ),
          ),
        ),
        Positioned(
          bottom: -150,
          left: -130,
          child: Container(
            width: 340,
            height: 340,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x0A0D5789),
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const LogoImage(heightFactor: .16, widthFactor: .94),
                const SizedBox(height: 22),
                Container(
                  width: 56,
                  height: 3,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 25),
                CustomLoading(color: context.colorScheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
