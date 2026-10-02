import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

enum OnboardingPage {
  welcome(
    0,
    'assets/images/img_welcome.png',
    LocaleKeys.onboarding_welcome_description,
    LocaleKeys.onboarding_welcome_title,
  ),
  welcome2(
    1,
    'assets/images/img_welcome2.png',
    LocaleKeys.onboarding_welcome2_description,
    LocaleKeys.onboarding_welcome2_title,
  ),
  welcome3(
    2,
    'assets/images/img_welcome3.png',
    LocaleKeys.onboarding_welcome3_description,
    LocaleKeys.onboarding_welcome3_title,
  );

  const OnboardingPage(
    this._index,
    this._image,
    this._description,
    this._title,
  );
  final int _index;
  final String _image;
  final String _description;
  final String _title;

  int get getIndex => _index;
  String get getDescription => _description.translate;
  String get getImage => _image;
  String get getTitle => _title.translate;
}
