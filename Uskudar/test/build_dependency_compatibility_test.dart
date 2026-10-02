import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payinall/domain/entities/contact_info.dart';

void main() {
  testWidgets('Font Awesome icons render with the new wrapper type', (
    tester,
  ) async {
    const contact = ContactInfoModel(
      title: 'Test',
      content: 'Test',
      iconData: FontAwesomeIcons.phone,
    );
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: FaIcon(contact.iconData))),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(FaIcon), findsOneWidget);
  });

  testWidgets('HTML selector styles remain compatible', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Html(
            data: '<p class="message">Compatibility</p>',
            style: {'.message': Style(color: Colors.red)},
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byType(RichText), findsWidgets);
  });
}
