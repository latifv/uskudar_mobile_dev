final class ImageAssetsConstants {
  const ImageAssetsConstants._();

  static String welcome = _toPng('welcome');
  static String welcome2 = _toPng('welcome2');
  static String welcome3 = _toPng('welcome3');
  static String register = _toPng('register');
  static String qrGenerate = _toPng('qr_generate');
  static String poweredIWallet = _toPng('powered_iwallet');
  static String fuel = _toJpg('fuel');
  static String gift = _toJpg('gift');
  static String metropol = _toJpg('metropol');
  static String get paycoreTroyFront => _paycoreCard('troy_front');
  static String get paycoreTroyBack => _paycoreCard('troy_back');
  static String get paycoreMasterFront => _paycoreCard('master_front');
  static String get paycoreMasterBack => _paycoreCard('master_back');

  static String _toPng(String name) => 'assets/images/img_$name.png';
  static String _toJpg(String name) => 'assets/images/img_$name.jpg';
  static String _paycoreCard(String name) =>
      'assets/images/paycore_cards/$name.png';
}
