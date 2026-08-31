import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/data/config/environment_config.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/domain/entities/metropol_user_balance.dart';
import 'package:payinall/domain/enums/app_environment.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/widgets/gift_check_coupon_item.dart';
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

    expect(tester.getSize(find.byType(GiftCheckCategoryItem)).height, 60);
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
              name: 'Çok Uzun Marka İsmi Örneği ER',
              cashbackRate: 0.075,
              logo: '',
            ),
            onTap: () {},
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Çok Uzun Marka İsmi Örneği',
      ),
      findsOneWidget,
    );
    expect(find.text('%7.5'), findsOneWidget);
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

  testWidgets('selected gift coupon has a visible selection state', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 145,
          height: 150,
          child: GiftCheckCouponItem(
            coupon: const GiftCheckCoupon(
              id: 'coupon-1',
              amount: 500,
              stock: 2,
            ),
            cashbackRate: 0.03,
            isSelected: true,
            onSelect: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sticky CTA stays compact and invokes its action', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      host(
        AlisverislioStickyCta(
          title: 'Hediye Çeki Satın Al',
          subtitle: 'Seçili hediye çekini satın al',
          onPressed: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.byType(AlisverislioStickyCta));
    await tester.pump();

    expect(tapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('integration empty state stays calm and compact', (tester) async {
    await tester.pumpWidget(
      host(
        const AlisverislioStateView(
          icon: Icons.confirmation_number_outlined,
          title: 'Henüz kuponunuz yok',
          description: 'Kuponlarınız burada görüntülenecek.',
        ),
      ),
    );

    expect(find.text('Henüz kuponunuz yok'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
