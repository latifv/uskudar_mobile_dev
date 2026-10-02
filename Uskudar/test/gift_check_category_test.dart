import 'package:flutter_test/flutter_test.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';

void main() {
  test(
    'recognizes Lio Kart without treating regular categories as Lio Kart',
    () {
      expect(
        const GiftCheckCategory(id: 'lio', name: 'Lio Kart').isLioCard,
        isTrue,
      );
      expect(
        const GiftCheckCategory(id: 'lio-spaced', name: 'Lio-Kart').isLioCard,
        isTrue,
      );
      expect(
        const GiftCheckCategory(id: 'market', name: 'Market').isLioCard,
        isFalse,
      );
    },
  );
}
