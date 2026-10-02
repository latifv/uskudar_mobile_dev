import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/presentation/pages/paycore_cards/paycore_new_address_fields.dart';

void main() {
  test('Address and district boundary validation', () {
    for (final count in [50, 51, 199, 200]) {
      expect(PaycoreNewAddressFields.validationError('Ş' * count, 'M' * 50, '35000'), isNull);
    }
    expect(PaycoreNewAddressFields.validationError('Ş' * 201, 'Mahalle', '35000'), contains('200'));
    expect(PaycoreNewAddressFields.validationError('Sokak', 'M' * 51, '35000'), contains('50'));
    expect(PaycoreNewAddressFields.validationError('Sokak', 'Mahalle', '3500'), contains('Posta'));
  });
  for (final cardForm in [false, true]) {
    testWidgets(
      'New ${cardForm ? "card" : "customer"} address starts empty and changes county with city',
      (tester) async {
        final controllers = List.generate(6, (_) => TextEditingController());
        addTearDown(() {
          for (final controller in controllers) {
            controller.dispose();
          }
        });
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: PaycoreNewAddressFields(
                  cities: const [
                    MetropolCity(city: 'İzmir', county: ['Bornova']),
                    MetropolCity(city: 'Ankara', county: ['Çankaya']),
                  ],
                  city: controllers[0],
                  town: controllers[1],
                  district: controllers[2],
                  street: controllers[3],
                  zip: controllers[4],
                ),
              ),
            ),
          ),
        );
        expect(controllers.every((c) => c.text.isEmpty), isTrue);
        expect(find.text('Adres Satırı 2'), findsNothing);
        expect(find.text('Açık Adres *'), findsOneWidget);
        final streetField = find.byWidgetPredicate((w) => w is TextField && w.controller == controllers[3]);
        await tester.enterText(streetField, 'Ş' * 201);
        await tester.pump();
        expect(controllers[3].text.length, 201);
        expect(find.text('Açık Adres en fazla 200 karakter olmalıdır.'), findsOneWidget);
        controllers[3].clear();
        await tester.pump();
        final codeFields = tester
            .widgetList<TextField>(find.byType(TextField))
            .where((f) => f.enabled == false);
        expect(codeFields, isEmpty);
        expect(find.text('İl Kodu'), findsNothing);
        expect(find.text('İlçe Kodu'), findsNothing);
        var dropdowns = tester
            .widgetList<DropdownButtonFormField<String>>(
              find.byType(DropdownButtonFormField<String>),
            )
            .toList();
        expect(dropdowns[1].onChanged, isNull);
        dropdowns[0].onChanged!('İzmir');
        await tester.pumpAndSettle();
        dropdowns = tester
            .widgetList<DropdownButtonFormField<String>>(
              find.byType(DropdownButtonFormField<String>),
            )
            .toList();
        dropdowns[1].onChanged!('Bornova');
        await tester.pumpAndSettle();
        expect(controllers[0].text, 'İzmir');
        expect(controllers[1].text, 'Bornova');
        dropdowns = tester
            .widgetList<DropdownButtonFormField<String>>(
              find.byType(DropdownButtonFormField<String>),
            )
            .toList();
        dropdowns[0].onChanged!('Ankara');
        await tester.pumpAndSettle();
        expect(controllers[1].text, isEmpty);
        expect(find.text('Bornova'), findsNothing);
        expect(
          find.text('Adres Satırı 2'),
          findsNothing,
        );
      },
    );
  }

  testWidgets(
    'Unavailable location list does not allow manual city or county guessing',
    (tester) async {
      final controllers = List.generate(5, (_) => TextEditingController());
      addTearDown(() {
        for (final c in controllers) {
          c.dispose();
        }
      });
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: PaycoreNewAddressFields(
                cities: const [],
                city: controllers[0],
                town: controllers[1],
                district: controllers[2],
                street: controllers[3],
                zip: controllers[4],
              ),
            ),
          ),
        ),
      );
      final dropdowns = tester.widgetList<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );
      expect(dropdowns.every((f) => f.onChanged == null), isTrue);
      expect(
        find.textContaining('İl ve ilçe listesi yüklenemedi'),
        findsOneWidget,
      );
    },
  );
}
