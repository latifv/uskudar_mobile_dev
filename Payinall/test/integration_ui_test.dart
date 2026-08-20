import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/data/config/environment_config.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/entities/metropol_user_balance.dart';
import 'package:payinall/domain/enums/app_environment.dart';
import 'package:payinall/presentation/pages/gift_check_brands/widgets/gift_check_brand_card.dart';
import 'package:payinall/presentation/pages/gift_checks/widgets/gift_check_category_item.dart';
import 'package:payinall/presentation/pages/metropol/widgets/metropol_balance_card.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

void main() {
  setUpAll(() => EnvironmentConfig.initialize(AppEnvironment.test));

  Widget host(Widget child, {double width = 320}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 640)),
        child: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
  }

  testWidgets('category row stays compact on a small screen', (tester) async {
    await tester.pumpWidget(
      host(
        GiftCheckCategoryItem(
          category: const GiftCheckCategory(id: '1', name: 'Alışveriş Çeki'),
          onTap: () {},
        ),
      ),
    );

    expect(tester.getSize(find.byType(GiftCheckCategoryItem)).height, 68);
    expect(tester.takeException(), isNull);
  });

  testWidgets('long brand name and cashback do not overflow', (tester) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 145,
          height: 140,
          child: GiftCheckBrandCard(
            brand: const GiftCheckBrand(
              id: '1',
              name: 'Çok Uzun Marka İsmi Örneği',
              cashbackRate: 0.075,
              logo: '',
            ),
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('%7.5 Nakit İade'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('two balance values fit on a small screen', (tester) async {
    await tester.pumpWidget(
      host(
        const Padding(
          padding: EdgeInsets.all(12),
          child: MetropolBalanceCard(
            balance: MetropolUserBalance(
              restoBalance: 123456.78,
              giftBalance: 98765.43,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Resto Bakiye'), findsOneWidget);
    expect(find.text('Gift Bakiye'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('integration action card supports two-line labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 145,
          height: 74,
          child: IntegrationActionCard(
            icon: Icons.receipt_long_rounded,
            label: 'Çok Uzun İşlem Geçmişi Başlığı',
            onTap: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
