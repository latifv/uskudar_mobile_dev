final class IconAssetsConstants {
  const IconAssetsConstants._();

  static String get logo => _toPng('logo');
  static String get splash => _toPng('splash');
  static String get menu => _toPng('menu');

  static String _toPng(String name) => 'assets/icons/ic_$name.png';
  // static String _toSvg(String name) => 'assets/icons/ic_$name.svg';
}
