// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AccountLimitsScreen]
class AccountLimitsRoute extends PageRouteInfo<void> {
  const AccountLimitsRoute({List<PageRouteInfo>? children})
    : super(AccountLimitsRoute.name, initialChildren: children);

  static const String name = 'AccountLimitsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountLimitsScreen();
    },
  );
}

/// generated route for
/// [AccountVerificationScreen]
class AccountVerificationRoute
    extends PageRouteInfo<AccountVerificationRouteArgs> {
  AccountVerificationRoute({
    required String phoneNumber,
    required String code,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AccountVerificationRoute.name,
         args: AccountVerificationRouteArgs(
           phoneNumber: phoneNumber,
           code: code,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AccountVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AccountVerificationRouteArgs>();
      return AccountVerificationScreen(
        phoneNumber: args.phoneNumber,
        code: args.code,
        key: args.key,
      );
    },
  );
}

class AccountVerificationRouteArgs {
  const AccountVerificationRouteArgs({
    required this.phoneNumber,
    required this.code,
    this.key,
  });

  final String phoneNumber;

  final String code;

  final Key? key;

  @override
  String toString() {
    return 'AccountVerificationRouteArgs{phoneNumber: $phoneNumber, code: $code, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AccountVerificationRouteArgs) return false;
    return phoneNumber == other.phoneNumber &&
        code == other.code &&
        key == other.key;
  }

  @override
  int get hashCode => phoneNumber.hashCode ^ code.hashCode ^ key.hashCode;
}

/// generated route for
/// [AddBankAccountScreen]
class AddBankAccountRoute extends PageRouteInfo<void> {
  const AddBankAccountRoute({List<PageRouteInfo>? children})
    : super(AddBankAccountRoute.name, initialChildren: children);

  static const String name = 'AddBankAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddBankAccountScreen();
    },
  );
}

/// generated route for
/// [AddFuelCardScreen]
class AddFuelCardRoute extends PageRouteInfo<AddFuelCardRouteArgs> {
  AddFuelCardRoute({
    FuelProvider provider = FuelProvider.shell,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AddFuelCardRoute.name,
         args: AddFuelCardRouteArgs(provider: provider, key: key),
         initialChildren: children,
       );

  static const String name = 'AddFuelCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddFuelCardRouteArgs>(
        orElse: () => const AddFuelCardRouteArgs(),
      );
      return AddFuelCardScreen(provider: args.provider, key: args.key);
    },
  );
}

class AddFuelCardRouteArgs {
  const AddFuelCardRouteArgs({this.provider = FuelProvider.shell, this.key});

  final FuelProvider provider;

  final Key? key;

  @override
  String toString() {
    return 'AddFuelCardRouteArgs{provider: $provider, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AddFuelCardRouteArgs) return false;
    return provider == other.provider && key == other.key;
  }

  @override
  int get hashCode => provider.hashCode ^ key.hashCode;
}

/// generated route for
/// [AddressPreviewScreen]
class AddressPreviewRoute extends PageRouteInfo<void> {
  const AddressPreviewRoute({List<PageRouteInfo>? children})
    : super(AddressPreviewRoute.name, initialChildren: children);

  static const String name = 'AddressPreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddressPreviewScreen();
    },
  );
}

/// generated route for
/// [AdminScreen]
class AdminRoute extends PageRouteInfo<void> {
  const AdminRoute({List<PageRouteInfo>? children})
    : super(AdminRoute.name, initialChildren: children);

  static const String name = 'AdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminScreen();
    },
  );
}

/// generated route for
/// [AgreementScreen]
class AgreementRoute extends PageRouteInfo<AgreementRouteArgs> {
  AgreementRoute({
    required String agreementType,
    required bool isRead,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AgreementRoute.name,
         args: AgreementRouteArgs(
           agreementType: agreementType,
           isRead: isRead,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'AgreementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AgreementRouteArgs>();
      return AgreementScreen(
        agreementType: args.agreementType,
        isRead: args.isRead,
        key: args.key,
      );
    },
  );
}

class AgreementRouteArgs {
  const AgreementRouteArgs({
    required this.agreementType,
    required this.isRead,
    this.key,
  });

  final String agreementType;

  final bool isRead;

  final Key? key;

  @override
  String toString() {
    return 'AgreementRouteArgs{agreementType: $agreementType, isRead: $isRead, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AgreementRouteArgs) return false;
    return agreementType == other.agreementType &&
        isRead == other.isRead &&
        key == other.key;
  }

  @override
  int get hashCode => agreementType.hashCode ^ isRead.hashCode ^ key.hashCode;
}

/// generated route for
/// [AgreementsScreen]
class AgreementsRoute extends PageRouteInfo<void> {
  const AgreementsRoute({List<PageRouteInfo>? children})
    : super(AgreementsRoute.name, initialChildren: children);

  static const String name = 'AgreementsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AgreementsScreen();
    },
  );
}

/// generated route for
/// [AlisverislioScreen]
class AlisverislioRoute extends PageRouteInfo<void> {
  const AlisverislioRoute({List<PageRouteInfo>? children})
    : super(AlisverislioRoute.name, initialChildren: children);

  static const String name = 'AlisverislioRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AlisverislioScreen();
    },
  );
}

/// generated route for
/// [AvatarSelectionScreen]
class AvatarSelectionRoute extends PageRouteInfo<void> {
  const AvatarSelectionRoute({List<PageRouteInfo>? children})
    : super(AvatarSelectionRoute.name, initialChildren: children);

  static const String name = 'AvatarSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AvatarSelectionScreen();
    },
  );
}

/// generated route for
/// [BackIdScanScreen]
class BackIdScanRoute extends PageRouteInfo<BackIdScanRouteArgs> {
  BackIdScanRoute({
    required String processId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BackIdScanRoute.name,
         args: BackIdScanRouteArgs(processId: processId, key: key),
         initialChildren: children,
       );

  static const String name = 'BackIdScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BackIdScanRouteArgs>();
      return BackIdScanScreen(processId: args.processId, key: args.key);
    },
  );
}

class BackIdScanRouteArgs {
  const BackIdScanRouteArgs({required this.processId, this.key});

  final String processId;

  final Key? key;

  @override
  String toString() {
    return 'BackIdScanRouteArgs{processId: $processId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BackIdScanRouteArgs) return false;
    return processId == other.processId && key == other.key;
  }

  @override
  int get hashCode => processId.hashCode ^ key.hashCode;
}

/// generated route for
/// [BankAccountsScreen]
class BankAccountsRoute extends PageRouteInfo<void> {
  const BankAccountsRoute({List<PageRouteInfo>? children})
    : super(BankAccountsRoute.name, initialChildren: children);

  static const String name = 'BankAccountsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BankAccountsScreen();
    },
  );
}

/// generated route for
/// [BankDetailScreen]
class BankDetailRoute extends PageRouteInfo<BankDetailRouteArgs> {
  BankDetailRoute({
    required AppBank bank,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BankDetailRoute.name,
         args: BankDetailRouteArgs(bank: bank, key: key),
         initialChildren: children,
       );

  static const String name = 'BankDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BankDetailRouteArgs>();
      return BankDetailScreen(bank: args.bank, key: args.key);
    },
  );
}

class BankDetailRouteArgs {
  const BankDetailRouteArgs({required this.bank, this.key});

  final AppBank bank;

  final Key? key;

  @override
  String toString() {
    return 'BankDetailRouteArgs{bank: $bank, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BankDetailRouteArgs) return false;
    return bank == other.bank && key == other.key;
  }

  @override
  int get hashCode => bank.hashCode ^ key.hashCode;
}

/// generated route for
/// [BankListScreen]
class BankListRoute extends PageRouteInfo<void> {
  const BankListRoute({List<PageRouteInfo>? children})
    : super(BankListRoute.name, initialChildren: children);

  static const String name = 'BankListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BankListScreen();
    },
  );
}

/// generated route for
/// [BillPaymentScreen]
class BillPaymentRoute extends PageRouteInfo<BillPaymentRouteArgs> {
  BillPaymentRoute({
    String? initialProductId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         BillPaymentRoute.name,
         args: BillPaymentRouteArgs(
           initialProductId: initialProductId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'BillPaymentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BillPaymentRouteArgs>(
        orElse: () => const BillPaymentRouteArgs(),
      );
      return BillPaymentScreen(
        initialProductId: args.initialProductId,
        key: args.key,
      );
    },
  );
}

class BillPaymentRouteArgs {
  const BillPaymentRouteArgs({this.initialProductId, this.key});

  final String? initialProductId;

  final Key? key;

  @override
  String toString() {
    return 'BillPaymentRouteArgs{initialProductId: $initialProductId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BillPaymentRouteArgs) return false;
    return initialProductId == other.initialProductId && key == other.key;
  }

  @override
  int get hashCode => initialProductId.hashCode ^ key.hashCode;
}

/// generated route for
/// [CampaignQrCodeScreen]
class CampaignQrCodeRoute extends PageRouteInfo<CampaignQrCodeRouteArgs> {
  CampaignQrCodeRoute({
    required String qrCode,
    required String imageUrl,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         CampaignQrCodeRoute.name,
         args: CampaignQrCodeRouteArgs(
           qrCode: qrCode,
           imageUrl: imageUrl,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'CampaignQrCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CampaignQrCodeRouteArgs>();
      return CampaignQrCodeScreen(
        qrCode: args.qrCode,
        imageUrl: args.imageUrl,
        key: args.key,
      );
    },
  );
}

class CampaignQrCodeRouteArgs {
  const CampaignQrCodeRouteArgs({
    required this.qrCode,
    required this.imageUrl,
    this.key,
  });

  final String qrCode;

  final String imageUrl;

  final Key? key;

  @override
  String toString() {
    return 'CampaignQrCodeRouteArgs{qrCode: $qrCode, imageUrl: $imageUrl, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CampaignQrCodeRouteArgs) return false;
    return qrCode == other.qrCode &&
        imageUrl == other.imageUrl &&
        key == other.key;
  }

  @override
  int get hashCode => qrCode.hashCode ^ imageUrl.hashCode ^ key.hashCode;
}

/// generated route for
/// [CampaignsScreen]
class CampaignsRoute extends PageRouteInfo<void> {
  const CampaignsRoute({List<PageRouteInfo>? children})
    : super(CampaignsRoute.name, initialChildren: children);

  static const String name = 'CampaignsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CampaignsScreen();
    },
  );
}

/// generated route for
/// [ChangeEmailScreen]
class ChangeEmailRoute extends PageRouteInfo<void> {
  const ChangeEmailRoute({List<PageRouteInfo>? children})
    : super(ChangeEmailRoute.name, initialChildren: children);

  static const String name = 'ChangeEmailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangeEmailScreen();
    },
  );
}

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [ChangePhoneScreen]
class ChangePhoneRoute extends PageRouteInfo<ChangePhoneRouteArgs> {
  ChangePhoneRoute({
    required String question,
    required String tcNumber,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ChangePhoneRoute.name,
         args: ChangePhoneRouteArgs(
           question: question,
           tcNumber: tcNumber,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ChangePhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChangePhoneRouteArgs>();
      return ChangePhoneScreen(
        question: args.question,
        tcNumber: args.tcNumber,
        key: args.key,
      );
    },
  );
}

class ChangePhoneRouteArgs {
  const ChangePhoneRouteArgs({
    required this.question,
    required this.tcNumber,
    this.key,
  });

  final String question;

  final String tcNumber;

  final Key? key;

  @override
  String toString() {
    return 'ChangePhoneRouteArgs{question: $question, tcNumber: $tcNumber, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChangePhoneRouteArgs) return false;
    return question == other.question &&
        tcNumber == other.tcNumber &&
        key == other.key;
  }

  @override
  int get hashCode => question.hashCode ^ tcNumber.hashCode ^ key.hashCode;
}

/// generated route for
/// [CommissionRatesScreen]
class CommissionRatesRoute extends PageRouteInfo<void> {
  const CommissionRatesRoute({List<PageRouteInfo>? children})
    : super(CommissionRatesRoute.name, initialChildren: children);

  static const String name = 'CommissionRatesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CommissionRatesScreen();
    },
  );
}

/// generated route for
/// [ContactInfoScreen]
class ContactInfoRoute extends PageRouteInfo<void> {
  const ContactInfoRoute({List<PageRouteInfo>? children})
    : super(ContactInfoRoute.name, initialChildren: children);

  static const String name = 'ContactInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ContactInfoScreen();
    },
  );
}

/// generated route for
/// [CountrySelectionScreen]
class CountrySelectionRoute extends PageRouteInfo<void> {
  const CountrySelectionRoute({List<PageRouteInfo>? children})
    : super(CountrySelectionRoute.name, initialChildren: children);

  static const String name = 'CountrySelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CountrySelectionScreen();
    },
  );
}

/// generated route for
/// [CustomerCouponsScreen]
class CustomerCouponsRoute extends PageRouteInfo<void> {
  const CustomerCouponsRoute({List<PageRouteInfo>? children})
    : super(CustomerCouponsRoute.name, initialChildren: children);

  static const String name = 'CustomerCouponsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomerCouponsScreen();
    },
  );
}

/// generated route for
/// [CustomerDemandScreen]
class CustomerDemandRoute extends PageRouteInfo<void> {
  const CustomerDemandRoute({List<PageRouteInfo>? children})
    : super(CustomerDemandRoute.name, initialChildren: children);

  static const String name = 'CustomerDemandRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CustomerDemandScreen();
    },
  );
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [EmailVerificationScreen]
class EmailVerificationRoute extends PageRouteInfo<EmailVerificationRouteArgs> {
  EmailVerificationRoute({
    required int emailVerificationType,
    required String processCode,
    String? email,
    String? newEmail,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         EmailVerificationRoute.name,
         args: EmailVerificationRouteArgs(
           emailVerificationType: emailVerificationType,
           processCode: processCode,
           email: email,
           newEmail: newEmail,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'EmailVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EmailVerificationRouteArgs>();
      return EmailVerificationScreen(
        emailVerificationType: args.emailVerificationType,
        processCode: args.processCode,
        email: args.email,
        newEmail: args.newEmail,
        key: args.key,
      );
    },
  );
}

class EmailVerificationRouteArgs {
  const EmailVerificationRouteArgs({
    required this.emailVerificationType,
    required this.processCode,
    this.email,
    this.newEmail,
    this.key,
  });

  final int emailVerificationType;

  final String processCode;

  final String? email;

  final String? newEmail;

  final Key? key;

  @override
  String toString() {
    return 'EmailVerificationRouteArgs{emailVerificationType: $emailVerificationType, processCode: $processCode, email: $email, newEmail: $newEmail, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EmailVerificationRouteArgs) return false;
    return emailVerificationType == other.emailVerificationType &&
        processCode == other.processCode &&
        email == other.email &&
        newEmail == other.newEmail &&
        key == other.key;
  }

  @override
  int get hashCode =>
      emailVerificationType.hashCode ^
      processCode.hashCode ^
      email.hashCode ^
      newEmail.hashCode ^
      key.hashCode;
}

/// generated route for
/// [FaceScanScreen]
class FaceScanRoute extends PageRouteInfo<FaceScanRouteArgs> {
  FaceScanRoute({
    required String processId,
    required String? image,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FaceScanRoute.name,
         args: FaceScanRouteArgs(processId: processId, image: image, key: key),
         initialChildren: children,
       );

  static const String name = 'FaceScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FaceScanRouteArgs>();
      return FaceScanScreen(
        processId: args.processId,
        image: args.image,
        key: args.key,
      );
    },
  );
}

class FaceScanRouteArgs {
  const FaceScanRouteArgs({
    required this.processId,
    required this.image,
    this.key,
  });

  final String processId;

  final String? image;

  final Key? key;

  @override
  String toString() {
    return 'FaceScanRouteArgs{processId: $processId, image: $image, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FaceScanRouteArgs) return false;
    return processId == other.processId &&
        image == other.image &&
        key == other.key;
  }

  @override
  int get hashCode => processId.hashCode ^ image.hashCode ^ key.hashCode;
}

/// generated route for
/// [FaqScreen]
class FaqRoute extends PageRouteInfo<void> {
  const FaqRoute({List<PageRouteInfo>? children})
    : super(FaqRoute.name, initialChildren: children);

  static const String name = 'FaqRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FaqScreen();
    },
  );
}

/// generated route for
/// [ForgotPasswordScreen]
class ForgotPasswordRoute extends PageRouteInfo<ForgotPasswordRouteArgs> {
  ForgotPasswordRoute({
    required String question,
    required String tcNumber,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ForgotPasswordRoute.name,
         args: ForgotPasswordRouteArgs(
           question: question,
           tcNumber: tcNumber,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ForgotPasswordRouteArgs>();
      return ForgotPasswordScreen(
        question: args.question,
        tcNumber: args.tcNumber,
        key: args.key,
      );
    },
  );
}

class ForgotPasswordRouteArgs {
  const ForgotPasswordRouteArgs({
    required this.question,
    required this.tcNumber,
    this.key,
  });

  final String question;

  final String tcNumber;

  final Key? key;

  @override
  String toString() {
    return 'ForgotPasswordRouteArgs{question: $question, tcNumber: $tcNumber, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ForgotPasswordRouteArgs) return false;
    return question == other.question &&
        tcNumber == other.tcNumber &&
        key == other.key;
  }

  @override
  int get hashCode => question.hashCode ^ tcNumber.hashCode ^ key.hashCode;
}

/// generated route for
/// [FrontIdScanScreen]
class FrontIdScanRoute extends PageRouteInfo<void> {
  const FrontIdScanRoute({List<PageRouteInfo>? children})
    : super(FrontIdScanRoute.name, initialChildren: children);

  static const String name = 'FrontIdScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FrontIdScanScreen();
    },
  );
}

/// generated route for
/// [FuelCardTopUpScreen]
class FuelCardTopUpRoute extends PageRouteInfo<FuelCardTopUpRouteArgs> {
  FuelCardTopUpRoute({
    required int fuelCardId,
    required String cardNo,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FuelCardTopUpRoute.name,
         args: FuelCardTopUpRouteArgs(
           fuelCardId: fuelCardId,
           cardNo: cardNo,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'FuelCardTopUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FuelCardTopUpRouteArgs>();
      return FuelCardTopUpScreen(
        fuelCardId: args.fuelCardId,
        cardNo: args.cardNo,
        key: args.key,
      );
    },
  );
}

class FuelCardTopUpRouteArgs {
  const FuelCardTopUpRouteArgs({
    required this.fuelCardId,
    required this.cardNo,
    this.key,
  });

  final int fuelCardId;

  final String cardNo;

  final Key? key;

  @override
  String toString() {
    return 'FuelCardTopUpRouteArgs{fuelCardId: $fuelCardId, cardNo: $cardNo, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FuelCardTopUpRouteArgs) return false;
    return fuelCardId == other.fuelCardId &&
        cardNo == other.cardNo &&
        key == other.key;
  }

  @override
  int get hashCode => fuelCardId.hashCode ^ cardNo.hashCode ^ key.hashCode;
}

/// generated route for
/// [FuelCardsScreen]
class FuelCardsRoute extends PageRouteInfo<void> {
  const FuelCardsRoute({List<PageRouteInfo>? children})
    : super(FuelCardsRoute.name, initialChildren: children);

  static const String name = 'FuelCardsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FuelCardsScreen();
    },
  );
}

/// generated route for
/// [GiftCheckBrandDetailScreen]
class GiftCheckBrandDetailRoute
    extends PageRouteInfo<GiftCheckBrandDetailRouteArgs> {
  GiftCheckBrandDetailRoute({
    required String brandId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         GiftCheckBrandDetailRoute.name,
         args: GiftCheckBrandDetailRouteArgs(brandId: brandId, key: key),
         initialChildren: children,
       );

  static const String name = 'GiftCheckBrandDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftCheckBrandDetailRouteArgs>();
      return GiftCheckBrandDetailScreen(brandId: args.brandId, key: args.key);
    },
  );
}

class GiftCheckBrandDetailRouteArgs {
  const GiftCheckBrandDetailRouteArgs({required this.brandId, this.key});

  final String brandId;

  final Key? key;

  @override
  String toString() {
    return 'GiftCheckBrandDetailRouteArgs{brandId: $brandId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GiftCheckBrandDetailRouteArgs) return false;
    return brandId == other.brandId && key == other.key;
  }

  @override
  int get hashCode => brandId.hashCode ^ key.hashCode;
}

/// generated route for
/// [GiftCheckBrandsScreen]
class GiftCheckBrandsRoute extends PageRouteInfo<GiftCheckBrandsRouteArgs> {
  GiftCheckBrandsRoute({
    required String categoryId,
    required String categoryName,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         GiftCheckBrandsRoute.name,
         args: GiftCheckBrandsRouteArgs(
           categoryId: categoryId,
           categoryName: categoryName,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'GiftCheckBrandsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GiftCheckBrandsRouteArgs>();
      return GiftCheckBrandsScreen(
        categoryId: args.categoryId,
        categoryName: args.categoryName,
        key: args.key,
      );
    },
  );
}

class GiftCheckBrandsRouteArgs {
  const GiftCheckBrandsRouteArgs({
    required this.categoryId,
    required this.categoryName,
    this.key,
  });

  final String categoryId;

  final String categoryName;

  final Key? key;

  @override
  String toString() {
    return 'GiftCheckBrandsRouteArgs{categoryId: $categoryId, categoryName: $categoryName, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! GiftCheckBrandsRouteArgs) return false;
    return categoryId == other.categoryId &&
        categoryName == other.categoryName &&
        key == other.key;
  }

  @override
  int get hashCode =>
      categoryId.hashCode ^ categoryName.hashCode ^ key.hashCode;
}

/// generated route for
/// [GiftChecksScreen]
class GiftChecksRoute extends PageRouteInfo<void> {
  const GiftChecksRoute({List<PageRouteInfo>? children})
    : super(GiftChecksRoute.name, initialChildren: children);

  static const String name = 'GiftChecksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GiftChecksScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [IWalletAgreementsScreen]
class IWalletAgreementsRoute extends PageRouteInfo<void> {
  const IWalletAgreementsRoute({List<PageRouteInfo>? children})
    : super(IWalletAgreementsRoute.name, initialChildren: children);

  static const String name = 'IWalletAgreementsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IWalletAgreementsScreen();
    },
  );
}

/// generated route for
/// [InternationalMoneyTransferScreen]
class InternationalMoneyTransferRoute
    extends PageRouteInfo<InternationalMoneyTransferRouteArgs> {
  InternationalMoneyTransferRoute({
    String? countryCode,
    String? transactionTypeCode,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         InternationalMoneyTransferRoute.name,
         args: InternationalMoneyTransferRouteArgs(
           countryCode: countryCode,
           transactionTypeCode: transactionTypeCode,
           key: key,
         ),
         rawPathParams: {
           'countryCode': countryCode,
           'transactionTypeCode': transactionTypeCode,
         },
         initialChildren: children,
       );

  static const String name = 'InternationalMoneyTransferRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<InternationalMoneyTransferRouteArgs>(
        orElse: () => InternationalMoneyTransferRouteArgs(
          countryCode: pathParams.optString('countryCode'),
          transactionTypeCode: pathParams.optString('transactionTypeCode'),
        ),
      );
      return InternationalMoneyTransferScreen(
        countryCode: args.countryCode,
        transactionTypeCode: args.transactionTypeCode,
        key: args.key,
      );
    },
  );
}

class InternationalMoneyTransferRouteArgs {
  const InternationalMoneyTransferRouteArgs({
    this.countryCode,
    this.transactionTypeCode,
    this.key,
  });

  final String? countryCode;

  final String? transactionTypeCode;

  final Key? key;

  @override
  String toString() {
    return 'InternationalMoneyTransferRouteArgs{countryCode: $countryCode, transactionTypeCode: $transactionTypeCode, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InternationalMoneyTransferRouteArgs) return false;
    return countryCode == other.countryCode &&
        transactionTypeCode == other.transactionTypeCode &&
        key == other.key;
  }

  @override
  int get hashCode =>
      countryCode.hashCode ^ transactionTypeCode.hashCode ^ key.hashCode;
}

/// generated route for
/// [InternationalTransferConfirmationScreen]
class InternationalTransferConfirmationRoute
    extends PageRouteInfo<InternationalTransferConfirmationRouteArgs> {
  InternationalTransferConfirmationRoute({
    required InternationalTransferResult transferResult,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         InternationalTransferConfirmationRoute.name,
         args: InternationalTransferConfirmationRouteArgs(
           transferResult: transferResult,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'InternationalTransferConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InternationalTransferConfirmationRouteArgs>();
      return InternationalTransferConfirmationScreen(
        transferResult: args.transferResult,
        key: args.key,
      );
    },
  );
}

class InternationalTransferConfirmationRouteArgs {
  const InternationalTransferConfirmationRouteArgs({
    required this.transferResult,
    this.key,
  });

  final InternationalTransferResult transferResult;

  final Key? key;

  @override
  String toString() {
    return 'InternationalTransferConfirmationRouteArgs{transferResult: $transferResult, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InternationalTransferConfirmationRouteArgs) return false;
    return transferResult == other.transferResult && key == other.key;
  }

  @override
  int get hashCode => transferResult.hashCode ^ key.hashCode;
}

/// generated route for
/// [InternationalTransferResultScreen]
class InternationalTransferResultRoute
    extends PageRouteInfo<InternationalTransferResultRouteArgs> {
  InternationalTransferResultRoute({
    required InternationalTransferResult transferResult,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         InternationalTransferResultRoute.name,
         args: InternationalTransferResultRouteArgs(
           transferResult: transferResult,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'InternationalTransferResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InternationalTransferResultRouteArgs>();
      return InternationalTransferResultScreen(
        transferResult: args.transferResult,
        key: args.key,
      );
    },
  );
}

class InternationalTransferResultRouteArgs {
  const InternationalTransferResultRouteArgs({
    required this.transferResult,
    this.key,
  });

  final InternationalTransferResult transferResult;

  final Key? key;

  @override
  String toString() {
    return 'InternationalTransferResultRouteArgs{transferResult: $transferResult, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! InternationalTransferResultRouteArgs) return false;
    return transferResult == other.transferResult && key == other.key;
  }

  @override
  int get hashCode => transferResult.hashCode ^ key.hashCode;
}

/// generated route for
/// [InternationalTransferSelectionScreen]
class InternationalTransferSelectionRoute extends PageRouteInfo<void> {
  const InternationalTransferSelectionRoute({List<PageRouteInfo>? children})
    : super(
        InternationalTransferSelectionRoute.name,
        initialChildren: children,
      );

  static const String name = 'InternationalTransferSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const InternationalTransferSelectionScreen();
    },
  );
}

/// generated route for
/// [LanguageSelectionScreen]
class LanguageSelectionRoute extends PageRouteInfo<void> {
  const LanguageSelectionRoute({List<PageRouteInfo>? children})
    : super(LanguageSelectionRoute.name, initialChildren: children);

  static const String name = 'LanguageSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LanguageSelectionScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<LoginRouteArgs> {
  LoginRoute({
    Key? key,
    String? phoneNumber,
    bool isSessionExpired = false,
    String? notAcceptableMessage,
    List<PageRouteInfo>? children,
  }) : super(
         LoginRoute.name,
         args: LoginRouteArgs(
           key: key,
           phoneNumber: phoneNumber,
           isSessionExpired: isSessionExpired,
           notAcceptableMessage: notAcceptableMessage,
         ),
         initialChildren: children,
       );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LoginRouteArgs>(
        orElse: () => const LoginRouteArgs(),
      );
      return LoginScreen(
        key: args.key,
        phoneNumber: args.phoneNumber,
        isSessionExpired: args.isSessionExpired,
        notAcceptableMessage: args.notAcceptableMessage,
      );
    },
  );
}

class LoginRouteArgs {
  const LoginRouteArgs({
    this.key,
    this.phoneNumber,
    this.isSessionExpired = false,
    this.notAcceptableMessage,
  });

  final Key? key;

  final String? phoneNumber;

  final bool isSessionExpired;

  final String? notAcceptableMessage;

  @override
  String toString() {
    return 'LoginRouteArgs{key: $key, phoneNumber: $phoneNumber, isSessionExpired: $isSessionExpired, notAcceptableMessage: $notAcceptableMessage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LoginRouteArgs) return false;
    return key == other.key &&
        phoneNumber == other.phoneNumber &&
        isSessionExpired == other.isSessionExpired &&
        notAcceptableMessage == other.notAcceptableMessage;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneNumber.hashCode ^
      isSessionExpired.hashCode ^
      notAcceptableMessage.hashCode;
}

/// generated route for
/// [MerchantDetailScreen]
class MerchantDetailRoute extends PageRouteInfo<MerchantDetailRouteArgs> {
  MerchantDetailRoute({
    required CampaignMerchant campaignMerchant,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         MerchantDetailRoute.name,
         args: MerchantDetailRouteArgs(
           campaignMerchant: campaignMerchant,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'MerchantDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MerchantDetailRouteArgs>();
      return MerchantDetailScreen(
        campaignMerchant: args.campaignMerchant,
        key: args.key,
      );
    },
  );
}

class MerchantDetailRouteArgs {
  const MerchantDetailRouteArgs({required this.campaignMerchant, this.key});

  final CampaignMerchant campaignMerchant;

  final Key? key;

  @override
  String toString() {
    return 'MerchantDetailRouteArgs{campaignMerchant: $campaignMerchant, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MerchantDetailRouteArgs) return false;
    return campaignMerchant == other.campaignMerchant && key == other.key;
  }

  @override
  int get hashCode => campaignMerchant.hashCode ^ key.hashCode;
}

/// generated route for
/// [MetropolGiftTransferScreen]
class MetropolGiftTransferRoute extends PageRouteInfo<void> {
  const MetropolGiftTransferRoute({List<PageRouteInfo>? children})
    : super(MetropolGiftTransferRoute.name, initialChildren: children);

  static const String name = 'MetropolGiftTransferRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MetropolGiftTransferScreen();
    },
  );
}

/// generated route for
/// [MetropolLocationsScreen]
class MetropolLocationsRoute extends PageRouteInfo<void> {
  const MetropolLocationsRoute({List<PageRouteInfo>? children})
    : super(MetropolLocationsRoute.name, initialChildren: children);

  static const String name = 'MetropolLocationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MetropolLocationsScreen();
    },
  );
}

/// generated route for
/// [MetropolScreen]
class MetropolRoute extends PageRouteInfo<void> {
  const MetropolRoute({List<PageRouteInfo>? children})
    : super(MetropolRoute.name, initialChildren: children);

  static const String name = 'MetropolRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MetropolScreen();
    },
  );
}

/// generated route for
/// [MetropolTransactionsScreen]
class MetropolTransactionsRoute extends PageRouteInfo<void> {
  const MetropolTransactionsRoute({List<PageRouteInfo>? children})
    : super(MetropolTransactionsRoute.name, initialChildren: children);

  static const String name = 'MetropolTransactionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MetropolTransactionsScreen();
    },
  );
}

/// generated route for
/// [MetropolTransferScreen]
class MetropolTransferRoute extends PageRouteInfo<void> {
  const MetropolTransferRoute({List<PageRouteInfo>? children})
    : super(MetropolTransferRoute.name, initialChildren: children);

  static const String name = 'MetropolTransferRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MetropolTransferScreen();
    },
  );
}

/// generated route for
/// [NfcScanScreen]
class NfcScanRoute extends PageRouteInfo<NfcScanRouteArgs> {
  NfcScanRoute({
    required String processId,
    required String mrz,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         NfcScanRoute.name,
         args: NfcScanRouteArgs(processId: processId, mrz: mrz, key: key),
         initialChildren: children,
       );

  static const String name = 'NfcScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NfcScanRouteArgs>();
      return NfcScanScreen(
        processId: args.processId,
        mrz: args.mrz,
        key: args.key,
      );
    },
  );
}

class NfcScanRouteArgs {
  const NfcScanRouteArgs({
    required this.processId,
    required this.mrz,
    this.key,
  });

  final String processId;

  final String mrz;

  final Key? key;

  @override
  String toString() {
    return 'NfcScanRouteArgs{processId: $processId, mrz: $mrz, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! NfcScanRouteArgs) return false;
    return processId == other.processId && mrz == other.mrz && key == other.key;
  }

  @override
  int get hashCode => processId.hashCode ^ mrz.hashCode ^ key.hashCode;
}

/// generated route for
/// [NotificationScreen]
class NotificationRoute extends PageRouteInfo<void> {
  const NotificationRoute({List<PageRouteInfo>? children})
    : super(NotificationRoute.name, initialChildren: children);

  static const String name = 'NotificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationScreen();
    },
  );
}

/// generated route for
/// [NotificationSettingsScreen]
class NotificationSettingsRoute extends PageRouteInfo<void> {
  const NotificationSettingsRoute({List<PageRouteInfo>? children})
    : super(NotificationSettingsRoute.name, initialChildren: children);

  static const String name = 'NotificationSettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationSettingsScreen();
    },
  );
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingScreen();
    },
  );
}

/// generated route for
/// [PageSearchScreen]
class RouteSearchRoute extends PageRouteInfo<void> {
  const RouteSearchRoute({List<PageRouteInfo>? children})
    : super(RouteSearchRoute.name, initialChildren: children);

  static const String name = 'RouteSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PageSearchScreen();
    },
  );
}

/// generated route for
/// [PasswordConfirmationScreen]
class PasswordConfirmationRoute
    extends PageRouteInfo<PasswordConfirmationRouteArgs> {
  PasswordConfirmationRoute({
    required String identifier,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         PasswordConfirmationRoute.name,
         args: PasswordConfirmationRouteArgs(identifier: identifier, key: key),
         initialChildren: children,
       );

  static const String name = 'PasswordConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PasswordConfirmationRouteArgs>();
      return PasswordConfirmationScreen(
        identifier: args.identifier,
        key: args.key,
      );
    },
  );
}

class PasswordConfirmationRouteArgs {
  const PasswordConfirmationRouteArgs({required this.identifier, this.key});

  final String identifier;

  final Key? key;

  @override
  String toString() {
    return 'PasswordConfirmationRouteArgs{identifier: $identifier, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PasswordConfirmationRouteArgs) return false;
    return identifier == other.identifier && key == other.key;
  }

  @override
  int get hashCode => identifier.hashCode ^ key.hashCode;
}

/// generated route for
/// [PendingMoneyRequestsScreen]
class PendingMoneyRequestsRoute extends PageRouteInfo<void> {
  const PendingMoneyRequestsRoute({List<PageRouteInfo>? children})
    : super(PendingMoneyRequestsRoute.name, initialChildren: children);

  static const String name = 'PendingMoneyRequestsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PendingMoneyRequestsScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [QrDisplayScreen]
class QrDisplayRoute extends PageRouteInfo<QrDisplayRouteArgs> {
  QrDisplayRoute({
    required Uint8List qrImage,
    required double amount,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         QrDisplayRoute.name,
         args: QrDisplayRouteArgs(qrImage: qrImage, amount: amount, key: key),
         initialChildren: children,
       );

  static const String name = 'QrDisplayRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QrDisplayRouteArgs>();
      return QrDisplayScreen(
        qrImage: args.qrImage,
        amount: args.amount,
        key: args.key,
      );
    },
  );
}

class QrDisplayRouteArgs {
  const QrDisplayRouteArgs({
    required this.qrImage,
    required this.amount,
    this.key,
  });

  final Uint8List qrImage;

  final double amount;

  final Key? key;

  @override
  String toString() {
    return 'QrDisplayRouteArgs{qrImage: $qrImage, amount: $amount, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QrDisplayRouteArgs) return false;
    return qrImage == other.qrImage &&
        amount == other.amount &&
        key == other.key;
  }

  @override
  int get hashCode => qrImage.hashCode ^ amount.hashCode ^ key.hashCode;
}

/// generated route for
/// [QrGenerateScreen]
class QrGenerateRoute extends PageRouteInfo<void> {
  const QrGenerateRoute({List<PageRouteInfo>? children})
    : super(QrGenerateRoute.name, initialChildren: children);

  static const String name = 'QrGenerateRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QrGenerateScreen();
    },
  );
}

/// generated route for
/// [QrScanScreen]
class QrScanRoute extends PageRouteInfo<void> {
  const QrScanRoute({List<PageRouteInfo>? children})
    : super(QrScanRoute.name, initialChildren: children);

  static const String name = 'QrScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QrScanScreen();
    },
  );
}

/// generated route for
/// [ReceiveMoneyScreen]
class ReceiveMoneyRoute extends PageRouteInfo<void> {
  const ReceiveMoneyRoute({List<PageRouteInfo>? children})
    : super(ReceiveMoneyRoute.name, initialChildren: children);

  static const String name = 'ReceiveMoneyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReceiveMoneyScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [RegisteredUsersScreen]
class RegisteredUsersRoute extends PageRouteInfo<void> {
  const RegisteredUsersRoute({List<PageRouteInfo>? children})
    : super(RegisteredUsersRoute.name, initialChildren: children);

  static const String name = 'RegisteredUsersRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisteredUsersScreen();
    },
  );
}

/// generated route for
/// [RequestMoneyScreen]
class RequestMoneyRoute extends PageRouteInfo<void> {
  const RequestMoneyRoute({List<PageRouteInfo>? children})
    : super(RequestMoneyRoute.name, initialChildren: children);

  static const String name = 'RequestMoneyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RequestMoneyScreen();
    },
  );
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<ResetPasswordRouteArgs> {
  ResetPasswordRoute({
    required String address,
    String? code,
    String? processCode,
    bool isMerchant = false,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ResetPasswordRoute.name,
         args: ResetPasswordRouteArgs(
           address: address,
           code: code,
           processCode: processCode,
           isMerchant: isMerchant,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetPasswordRouteArgs>();
      return ResetPasswordScreen(
        address: args.address,
        code: args.code,
        processCode: args.processCode,
        isMerchant: args.isMerchant,
        key: args.key,
      );
    },
  );
}

class ResetPasswordRouteArgs {
  const ResetPasswordRouteArgs({
    required this.address,
    this.code,
    this.processCode,
    this.isMerchant = false,
    this.key,
  });

  final String address;

  final String? code;

  final String? processCode;

  final bool isMerchant;

  final Key? key;

  @override
  String toString() {
    return 'ResetPasswordRouteArgs{address: $address, code: $code, processCode: $processCode, isMerchant: $isMerchant, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetPasswordRouteArgs) return false;
    return address == other.address &&
        code == other.code &&
        processCode == other.processCode &&
        isMerchant == other.isMerchant &&
        key == other.key;
  }

  @override
  int get hashCode =>
      address.hashCode ^
      code.hashCode ^
      processCode.hashCode ^
      isMerchant.hashCode ^
      key.hashCode;
}

/// generated route for
/// [ScoringQuestionsScreen]
class ScoringQuestionsRoute extends PageRouteInfo<void> {
  const ScoringQuestionsRoute({List<PageRouteInfo>? children})
    : super(ScoringQuestionsRoute.name, initialChildren: children);

  static const String name = 'ScoringQuestionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ScoringQuestionsScreen();
    },
  );
}

/// generated route for
/// [SecretQuestionScreen]
class SecretQuestionRoute extends PageRouteInfo<void> {
  const SecretQuestionRoute({List<PageRouteInfo>? children})
    : super(SecretQuestionRoute.name, initialChildren: children);

  static const String name = 'SecretQuestionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecretQuestionScreen();
    },
  );
}

/// generated route for
/// [SecurityChangePhoneScreen]
class SecurityChangePhoneRoute extends PageRouteInfo<void> {
  const SecurityChangePhoneRoute({List<PageRouteInfo>? children})
    : super(SecurityChangePhoneRoute.name, initialChildren: children);

  static const String name = 'SecurityChangePhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecurityChangePhoneScreen();
    },
  );
}

/// generated route for
/// [SecurityForgotPasswordScreen]
class SecurityForgotPasswordRoute extends PageRouteInfo<void> {
  const SecurityForgotPasswordRoute({List<PageRouteInfo>? children})
    : super(SecurityForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'SecurityForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SecurityForgotPasswordScreen();
    },
  );
}

/// generated route for
/// [SessionExpiredScreen]
class SessionExpiredRoute extends PageRouteInfo<void> {
  const SessionExpiredRoute({List<PageRouteInfo>? children})
    : super(SessionExpiredRoute.name, initialChildren: children);

  static const String name = 'SessionExpiredRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SessionExpiredScreen();
    },
  );
}

/// generated route for
/// [SetPasswordScreen]
class SetPasswordRoute extends PageRouteInfo<SetPasswordRouteArgs> {
  SetPasswordRoute({
    required String phoneNumber,
    required String code,
    required String email,
    required String firstName,
    required String lastName,
    required String tcNo,
    required String birthDate,
    required int userQuestionId,
    required String secretQuestion,
    required String seriNo,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         SetPasswordRoute.name,
         args: SetPasswordRouteArgs(
           phoneNumber: phoneNumber,
           code: code,
           email: email,
           firstName: firstName,
           lastName: lastName,
           tcNo: tcNo,
           birthDate: birthDate,
           userQuestionId: userQuestionId,
           secretQuestion: secretQuestion,
           seriNo: seriNo,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'SetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SetPasswordRouteArgs>();
      return SetPasswordScreen(
        phoneNumber: args.phoneNumber,
        code: args.code,
        email: args.email,
        firstName: args.firstName,
        lastName: args.lastName,
        tcNo: args.tcNo,
        birthDate: args.birthDate,
        userQuestionId: args.userQuestionId,
        secretQuestion: args.secretQuestion,
        seriNo: args.seriNo,
        key: args.key,
      );
    },
  );
}

class SetPasswordRouteArgs {
  const SetPasswordRouteArgs({
    required this.phoneNumber,
    required this.code,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.tcNo,
    required this.birthDate,
    required this.userQuestionId,
    required this.secretQuestion,
    required this.seriNo,
    this.key,
  });

  final String phoneNumber;

  final String code;

  final String email;

  final String firstName;

  final String lastName;

  final String tcNo;

  final String birthDate;

  final int userQuestionId;

  final String secretQuestion;

  final String seriNo;

  final Key? key;

  @override
  String toString() {
    return 'SetPasswordRouteArgs{phoneNumber: $phoneNumber, code: $code, email: $email, firstName: $firstName, lastName: $lastName, tcNo: $tcNo, birthDate: $birthDate, userQuestionId: $userQuestionId, secretQuestion: $secretQuestion, seriNo: $seriNo, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SetPasswordRouteArgs) return false;
    return phoneNumber == other.phoneNumber &&
        code == other.code &&
        email == other.email &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        tcNo == other.tcNo &&
        birthDate == other.birthDate &&
        userQuestionId == other.userQuestionId &&
        secretQuestion == other.secretQuestion &&
        seriNo == other.seriNo &&
        key == other.key;
  }

  @override
  int get hashCode =>
      phoneNumber.hashCode ^
      code.hashCode ^
      email.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      tcNo.hashCode ^
      birthDate.hashCode ^
      userQuestionId.hashCode ^
      secretQuestion.hashCode ^
      seriNo.hashCode ^
      key.hashCode;
}

/// generated route for
/// [SmsVerificationScreen]
class SmsVerificationRoute extends PageRouteInfo<SmsVerificationRouteArgs> {
  SmsVerificationRoute({
    required String phoneNumber,
    required int smsVerificationType,
    required String processCode,
    String? newPhoneNumber,
    String? identityNumber,
    String? securityQuestionAnswer,
    bool? rememberMe,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         SmsVerificationRoute.name,
         args: SmsVerificationRouteArgs(
           phoneNumber: phoneNumber,
           smsVerificationType: smsVerificationType,
           processCode: processCode,
           newPhoneNumber: newPhoneNumber,
           identityNumber: identityNumber,
           securityQuestionAnswer: securityQuestionAnswer,
           rememberMe: rememberMe,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'SmsVerificationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SmsVerificationRouteArgs>();
      return SmsVerificationScreen(
        phoneNumber: args.phoneNumber,
        smsVerificationType: args.smsVerificationType,
        processCode: args.processCode,
        newPhoneNumber: args.newPhoneNumber,
        identityNumber: args.identityNumber,
        securityQuestionAnswer: args.securityQuestionAnswer,
        rememberMe: args.rememberMe,
        key: args.key,
      );
    },
  );
}

class SmsVerificationRouteArgs {
  const SmsVerificationRouteArgs({
    required this.phoneNumber,
    required this.smsVerificationType,
    required this.processCode,
    this.newPhoneNumber,
    this.identityNumber,
    this.securityQuestionAnswer,
    this.rememberMe,
    this.key,
  });

  final String phoneNumber;

  final int smsVerificationType;

  final String processCode;

  final String? newPhoneNumber;

  final String? identityNumber;

  final String? securityQuestionAnswer;

  final bool? rememberMe;

  final Key? key;

  @override
  String toString() {
    return 'SmsVerificationRouteArgs{phoneNumber: $phoneNumber, smsVerificationType: $smsVerificationType, processCode: $processCode, newPhoneNumber: $newPhoneNumber, identityNumber: $identityNumber, securityQuestionAnswer: $securityQuestionAnswer, rememberMe: $rememberMe, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SmsVerificationRouteArgs) return false;
    return phoneNumber == other.phoneNumber &&
        smsVerificationType == other.smsVerificationType &&
        processCode == other.processCode &&
        newPhoneNumber == other.newPhoneNumber &&
        identityNumber == other.identityNumber &&
        securityQuestionAnswer == other.securityQuestionAnswer &&
        rememberMe == other.rememberMe &&
        key == other.key;
  }

  @override
  int get hashCode =>
      phoneNumber.hashCode ^
      smsVerificationType.hashCode ^
      processCode.hashCode ^
      newPhoneNumber.hashCode ^
      identityNumber.hashCode ^
      securityQuestionAnswer.hashCode ^
      rememberMe.hashCode ^
      key.hashCode;
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [TransactionDetailScreen]
class TransactionDetailRoute extends PageRouteInfo<TransactionDetailRouteArgs> {
  TransactionDetailRoute({
    required String transactionId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionDetailRoute.name,
         args: TransactionDetailRouteArgs(
           transactionId: transactionId,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'TransactionDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionDetailRouteArgs>();
      return TransactionDetailScreen(
        transactionId: args.transactionId,
        key: args.key,
      );
    },
  );
}

class TransactionDetailRouteArgs {
  const TransactionDetailRouteArgs({required this.transactionId, this.key});

  final String transactionId;

  final Key? key;

  @override
  String toString() {
    return 'TransactionDetailRouteArgs{transactionId: $transactionId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionDetailRouteArgs) return false;
    return transactionId == other.transactionId && key == other.key;
  }

  @override
  int get hashCode => transactionId.hashCode ^ key.hashCode;
}

/// generated route for
/// [TransactionHistoryScreen]
class TransactionHistoryRoute extends PageRouteInfo<void> {
  const TransactionHistoryRoute({List<PageRouteInfo>? children})
    : super(TransactionHistoryRoute.name, initialChildren: children);

  static const String name = 'TransactionHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TransactionHistoryScreen();
    },
  );
}

/// generated route for
/// [TransactionTypeSelectionScreen]
class TransactionTypeSelectionRoute
    extends PageRouteInfo<TransactionTypeSelectionRouteArgs> {
  TransactionTypeSelectionRoute({
    required String countryCode,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionTypeSelectionRoute.name,
         args: TransactionTypeSelectionRouteArgs(
           countryCode: countryCode,
           key: key,
         ),
         rawPathParams: {'countryCode': countryCode},
         initialChildren: children,
       );

  static const String name = 'TransactionTypeSelectionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TransactionTypeSelectionRouteArgs>(
        orElse: () => TransactionTypeSelectionRouteArgs(
          countryCode: pathParams.getString('countryCode'),
        ),
      );
      return TransactionTypeSelectionScreen(
        countryCode: args.countryCode,
        key: args.key,
      );
    },
  );
}

class TransactionTypeSelectionRouteArgs {
  const TransactionTypeSelectionRouteArgs({
    required this.countryCode,
    this.key,
  });

  final String countryCode;

  final Key? key;

  @override
  String toString() {
    return 'TransactionTypeSelectionRouteArgs{countryCode: $countryCode, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionTypeSelectionRouteArgs) return false;
    return countryCode == other.countryCode && key == other.key;
  }

  @override
  int get hashCode => countryCode.hashCode ^ key.hashCode;
}

/// generated route for
/// [TransferAmountScreen]
class TransferAmountRoute extends PageRouteInfo<TransferAmountRouteArgs> {
  TransferAmountRoute({
    required int transferMethod,
    String? walletAddress,
    double? amount,
    String? iban,
    String? phone,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         TransferAmountRoute.name,
         args: TransferAmountRouteArgs(
           transferMethod: transferMethod,
           walletAddress: walletAddress,
           amount: amount,
           iban: iban,
           phone: phone,
           key: key,
         ),
         rawPathParams: {
           'transferMethod': transferMethod,
           'walletAddress': walletAddress,
           'amount': amount,
         },
         initialChildren: children,
       );

  static const String name = 'TransferAmountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TransferAmountRouteArgs>(
        orElse: () => TransferAmountRouteArgs(
          transferMethod: pathParams.getInt('transferMethod'),
          walletAddress: pathParams.optString('walletAddress'),
          amount: pathParams.optDouble('amount'),
        ),
      );
      return TransferAmountScreen(
        transferMethod: args.transferMethod,
        walletAddress: args.walletAddress,
        amount: args.amount,
        iban: args.iban,
        phone: args.phone,
        key: args.key,
      );
    },
  );
}

class TransferAmountRouteArgs {
  const TransferAmountRouteArgs({
    required this.transferMethod,
    this.walletAddress,
    this.amount,
    this.iban,
    this.phone,
    this.key,
  });

  final int transferMethod;

  final String? walletAddress;

  final double? amount;

  final String? iban;

  final String? phone;

  final Key? key;

  @override
  String toString() {
    return 'TransferAmountRouteArgs{transferMethod: $transferMethod, walletAddress: $walletAddress, amount: $amount, iban: $iban, phone: $phone, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransferAmountRouteArgs) return false;
    return transferMethod == other.transferMethod &&
        walletAddress == other.walletAddress &&
        amount == other.amount &&
        iban == other.iban &&
        phone == other.phone &&
        key == other.key;
  }

  @override
  int get hashCode =>
      transferMethod.hashCode ^
      walletAddress.hashCode ^
      amount.hashCode ^
      iban.hashCode ^
      phone.hashCode ^
      key.hashCode;
}

/// generated route for
/// [TransferConfirmationScreen]
class TransferConfirmationRoute
    extends PageRouteInfo<TransferConfirmationRouteArgs> {
  TransferConfirmationRoute({
    required TransferMethod transferMethod,
    Key? key,
    WalletTransfer? walletTransfer,
    WithdrawTransfer? withdrawTransfer,
    List<PageRouteInfo>? children,
  }) : super(
         TransferConfirmationRoute.name,
         args: TransferConfirmationRouteArgs(
           transferMethod: transferMethod,
           key: key,
           walletTransfer: walletTransfer,
           withdrawTransfer: withdrawTransfer,
         ),
         initialChildren: children,
       );

  static const String name = 'TransferConfirmationRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferConfirmationRouteArgs>();
      return TransferConfirmationScreen(
        transferMethod: args.transferMethod,
        key: args.key,
        walletTransfer: args.walletTransfer,
        withdrawTransfer: args.withdrawTransfer,
      );
    },
  );
}

class TransferConfirmationRouteArgs {
  const TransferConfirmationRouteArgs({
    required this.transferMethod,
    this.key,
    this.walletTransfer,
    this.withdrawTransfer,
  });

  final TransferMethod transferMethod;

  final Key? key;

  final WalletTransfer? walletTransfer;

  final WithdrawTransfer? withdrawTransfer;

  @override
  String toString() {
    return 'TransferConfirmationRouteArgs{transferMethod: $transferMethod, key: $key, walletTransfer: $walletTransfer, withdrawTransfer: $withdrawTransfer}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransferConfirmationRouteArgs) return false;
    return transferMethod == other.transferMethod &&
        key == other.key &&
        walletTransfer == other.walletTransfer &&
        withdrawTransfer == other.withdrawTransfer;
  }

  @override
  int get hashCode =>
      transferMethod.hashCode ^
      key.hashCode ^
      walletTransfer.hashCode ^
      withdrawTransfer.hashCode;
}

/// generated route for
/// [TransferMethodScreen]
class TransferMethodRoute extends PageRouteInfo<TransferMethodRouteArgs> {
  TransferMethodRoute({
    Key? key,
    bool isWithdraw = false,
    List<PageRouteInfo>? children,
  }) : super(
         TransferMethodRoute.name,
         args: TransferMethodRouteArgs(key: key, isWithdraw: isWithdraw),
         initialChildren: children,
       );

  static const String name = 'TransferMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferMethodRouteArgs>(
        orElse: () => const TransferMethodRouteArgs(),
      );
      return TransferMethodScreen(key: args.key, isWithdraw: args.isWithdraw);
    },
  );
}

class TransferMethodRouteArgs {
  const TransferMethodRouteArgs({this.key, this.isWithdraw = false});

  final Key? key;

  final bool isWithdraw;

  @override
  String toString() {
    return 'TransferMethodRouteArgs{key: $key, isWithdraw: $isWithdraw}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransferMethodRouteArgs) return false;
    return key == other.key && isWithdraw == other.isWithdraw;
  }

  @override
  int get hashCode => key.hashCode ^ isWithdraw.hashCode;
}

/// generated route for
/// [TransferResultScreen]
class TransferResultRoute extends PageRouteInfo<TransferResultRouteArgs> {
  TransferResultRoute({
    required String transactionId,
    bool isSuccess = true,
    String? errorMessage,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         TransferResultRoute.name,
         args: TransferResultRouteArgs(
           transactionId: transactionId,
           isSuccess: isSuccess,
           errorMessage: errorMessage,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'TransferResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransferResultRouteArgs>();
      return TransferResultScreen(
        transactionId: args.transactionId,
        isSuccess: args.isSuccess,
        errorMessage: args.errorMessage,
        key: args.key,
      );
    },
  );
}

class TransferResultRouteArgs {
  const TransferResultRouteArgs({
    required this.transactionId,
    this.isSuccess = true,
    this.errorMessage,
    this.key,
  });

  final String transactionId;

  final bool isSuccess;

  final String? errorMessage;

  final Key? key;

  @override
  String toString() {
    return 'TransferResultRouteArgs{transactionId: $transactionId, isSuccess: $isSuccess, errorMessage: $errorMessage, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransferResultRouteArgs) return false;
    return transactionId == other.transactionId &&
        isSuccess == other.isSuccess &&
        errorMessage == other.errorMessage &&
        key == other.key;
  }

  @override
  int get hashCode =>
      transactionId.hashCode ^
      isSuccess.hashCode ^
      errorMessage.hashCode ^
      key.hashCode;
}

/// generated route for
/// [WrongLoginAttemptsScreen]
class WrongLoginAttemptsRoute extends PageRouteInfo<void> {
  const WrongLoginAttemptsRoute({List<PageRouteInfo>? children})
    : super(WrongLoginAttemptsRoute.name, initialChildren: children);

  static const String name = 'WrongLoginAttemptsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrongLoginAttemptsScreen();
    },
  );
}
