import 'package:flutter_test/flutter_test.dart';
import 'package:uskudar_mobile/presentation/shared/enums/bottom_page_enum.dart';

void main() {
  test('bottom navigation exposes finance destinations only', () {
    expect(BottomPageEnum.values, <BottomPageEnum>[
      BottomPageEnum.home,
      BottomPageEnum.transactions,
      BottomPageEnum.payments,
      BottomPageEnum.international,
    ]);
  });
}
