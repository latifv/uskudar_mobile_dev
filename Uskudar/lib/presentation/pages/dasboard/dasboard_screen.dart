import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/widgets/app_drawer.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_bottom_navigation_bar.dart';

@RoutePage()
final class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static void openDrawer(BuildContext context) {
    scaffoldKey.currentState?.openDrawer();
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.long2,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    return AutoTabsRouter(
      routes: [
        const HomeRoute(),
        const TransactionHistoryRoute(),
        if (!isMerchant) BillPaymentRoute(),
        const InternationalTransferSelectionRoute(),
      ],
      transitionBuilder: (context, child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      builder: (context, child) {
        final router = context.tabsRouter;
        return Scaffold(
          key: DashboardScreen.scaffoldKey,
          drawer: const AppDrawer(),
          onDrawerChanged: (isOpen) {
            if (isOpen) {
              unawaited(_animationController.forward());
            } else {
              unawaited(_animationController.reverse());
            }
          },
          extendBody: true,
          body: child,
          bottomNavigationBar: AnimatedBuilder(
            animation: router,
            builder: (context, child) => AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => SlideTransition(
                position:
                    Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0, 2),
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOutQuart,
                        reverseCurve: Curves.easeInQuart,
                      ),
                    ),
                child: CustomBottomNavigationBar(router: router),
              ),
            ),
          ),
        );
      },
    );
  }
}
