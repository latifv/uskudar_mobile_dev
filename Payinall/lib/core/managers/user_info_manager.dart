import 'package:payinall/data/network/config/api_constants.dart';
import 'package:payinall/domain/entities/current_user_info.dart';

final class UserInfoManager {
  // Ortak
  final _CommonInfo _common = _CommonInfo();
  // User
  final _UserInfo _user = _UserInfo();
  // Merchant
  _MerchantInfo? _merchant;
  bool _isMerchant = false;

  String? get walletAddress => _common.walletAddress;
  String? get firstName => _common.firstName;
  String? get lastName => _common.lastName;
  String? get email => _common.email;
  int? get addressType => _user.addressType;
  String? get gsmNumber => _user.gsmNumber;
  int? get statusId => _user.statusId;
  int? get notificationTypeId => _user.notificationTypeId;
  DateTime? get lastWrongPasswordDate => _user.lastWrongPasswordDate;
  String? get lastWrongIpAddress => _user.lastWrongIpAddress;
  int? get customerType => _user.customerType;
  String? get customerTypeName => _user.customerTypeName;
  bool get isAdmin => _user.isAdmin;
  bool? get isExWallet => _user.isExWallet;
  String? get image => _user.image;
  bool get isUserQuestionChange => _user.isUserQuestionChange;
  bool? get isMailConfirmed => _user.isMailConfirmed;
  bool get isMerchant => _isMerchant;
  int? get merchantId => _merchant?.merchantId;
  String? get merchantCompanyName => _merchant?.merchantCompanyName;
  num? get merchantBalance => _merchant?.balance;
  num? get merchantBlockBalance => _merchant?.blockBalance;
  num? get merchantAvailableBalance => _merchant?.availableBalance;
  bool? get isMerchantWalletLocked => _merchant?.isWalletLocked;

  void setUserInfo(CurrentUserInfo userInfo) {
    // Ortak
    _common.walletAddress = userInfo.customerNumber;
    _common.firstName = userInfo.firstName;
    _common.lastName = userInfo.lastName;
    _common.email = userInfo.email;
    // User
    _user.gsmNumber = userInfo.gsmNumber;
    _user.statusId = userInfo.statusId;
    _user.notificationTypeId = userInfo.notificationTypeId;
    _user.lastWrongPasswordDate = userInfo.lastWrongPasswordDate;
    _user.lastWrongIpAddress = userInfo.lastWrongIpAddress;
    _user.customerType = userInfo.customerType;
    _user.customerTypeName = userInfo.customerTypeName;
    _user.addressType = userInfo.addressType;

    if (ApiConstants.baseUrl ==
        'https://payinallwallettestapi.erpapay.com/api') {
      if (userInfo.gsmNumber == '5303862054' ||
          userInfo.gsmNumber == '5537285227' ||
          userInfo.gsmNumber == '5511699629' ||
          userInfo.gsmNumber == '5558500020') {
        _user.isAdmin = true;
      } else {
        _user.isAdmin = false;
      }
    } else {
      if (userInfo.gsmNumber == '5321660606') {
        _user.isAdmin = true;
      } else {
        _user.isAdmin = false;
      }
    }
    _user.isExWallet = userInfo.isExWallet;
    _user.image = userInfo.image;
    _user.isUserQuestionChange = userInfo.isUserQuestionChange;
    _user.isMailConfirmed = userInfo.isMailConfirmed;
  }

  void clearUserInfo() {
    _common.clear();
    _user.clear();
    _isMerchant = false;
    _merchant = null;
  }

  void setNotificationTypeId(int notificationTypeId) {
    _user.notificationTypeId = notificationTypeId;
  }

  void setCustomerType(int customerType) {
    _user.customerType = customerType;
  }

  void setIsExWallet(bool isExWallet) {
    _user.isExWallet = isExWallet;
  }

  void setImage(String? image) {
    _user.image = image;
  }

  void setIsMerchant(bool value) {
    _isMerchant = value;
  }

  void setMerchantInfo({
    required String customerNumber,
    required String firstName,
    required String lastName,
    required String email,
    required int merchantId,
    required String merchantCompanyName,
    required num balance,
    required num blockBalance,
    required num availableBalance,
    required bool isWalletLocked,
  }) {
    _common.walletAddress = customerNumber;
    _common.firstName = firstName;
    _common.lastName = lastName;
    _common.email = email;

    _isMerchant = true;
    _merchant = _MerchantInfo(
      merchantId: merchantId,
      merchantCompanyName: merchantCompanyName,
      balance: balance,
      blockBalance: blockBalance,
      availableBalance: availableBalance,
      isWalletLocked: isWalletLocked,
    );
  }
}

final class _CommonInfo {
  String? walletAddress;
  String? firstName;
  String? lastName;
  String? email;

  void clear() {
    walletAddress = null;
    firstName = null;
    lastName = null;
    email = null;
  }
}

final class _UserInfo {
  String? gsmNumber;
  int? statusId;
  int? notificationTypeId;
  DateTime? lastWrongPasswordDate;
  int? addressType;
  String? lastWrongIpAddress;
  int? customerType;
  String? customerTypeName;
  bool isAdmin = false;
  bool? isExWallet;
  String? image;
  bool isUserQuestionChange = false;
  bool? isMailConfirmed;

  void clear() {
    gsmNumber = null;
    statusId = null;
    notificationTypeId = null;
    lastWrongPasswordDate = null;
    addressType = null;
    lastWrongIpAddress = null;
    customerType = null;
    customerTypeName = null;
    isAdmin = false;
    isExWallet = null;
    image = null;
    isUserQuestionChange = false;
    isMailConfirmed = null;
  }
}

final class _MerchantInfo {
  _MerchantInfo({
    required this.merchantId,
    required this.merchantCompanyName,
    required this.balance,
    required this.blockBalance,
    required this.availableBalance,
    required this.isWalletLocked,
  });

  final int merchantId;
  final String merchantCompanyName;
  final num balance;
  final num blockBalance;
  final num availableBalance;
  final bool isWalletLocked;
}
