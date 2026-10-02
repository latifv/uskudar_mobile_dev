import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/widgets/app_drawer.dart';
import 'package:payinall/presentation/widgets/custom_bottom_navigation_bar.dart';

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
    return AutoTabsScaffold(
      scaffoldKey: DashboardScreen.scaffoldKey,
      drawer: const AppDrawer(),
      onDrawerChanged: (isOpen) {
        if (isOpen) {
          unawaited(_animationController.forward());
        } else {
          unawaited(_animationController.reverse());
        }
      },
      routes: [
        const HomeRoute(),
        const TransactionHistoryRoute(),
        if (!isMerchant) BillPaymentRoute(),
        const InternationalTransferSelectionRoute(),
      ],
      extendBody: true,
      bottomNavigationBuilder: (_, router) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return SlideTransition(
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
            );
          },
        );
      },
    );
  }
}
