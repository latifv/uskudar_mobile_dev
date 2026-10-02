import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/domain/entities/campaign_merchant.dart';
import 'package:uskudar_mobile/domain/entities/fuel_provider.dart';
import 'package:uskudar_mobile/domain/entities/international_transfer_result.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/account_limits/account_limits_screen.dart';
import 'package:uskudar_mobile/presentation/pages/add_bank_account/add_bank_account_screen.dart';
import 'package:uskudar_mobile/presentation/pages/add_fuel_card/add_fuel_card_screen.dart';
import 'package:uskudar_mobile/presentation/pages/address_preview/address_preview_screen.dart';
import 'package:uskudar_mobile/presentation/pages/admin/admin_screen.dart';
import 'package:uskudar_mobile/presentation/pages/agreement/agreement_screen.dart';
import 'package:uskudar_mobile/presentation/pages/agreements/screen/agreements_screen.dart';
import 'package:uskudar_mobile/presentation/pages/alisverislio/alisverislio_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/account_verification/account_verification_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/forgot_password/forgot_password_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/login/login_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/password_confirmation/password_confirmation_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/register/register_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/reset_password/reset_password_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/security_forgot_password/security_forgot_password_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/session_expired/session_expired_screen.dart';
import 'package:uskudar_mobile/presentation/pages/auth/set_password/set_password_screen.dart';
import 'package:uskudar_mobile/presentation/pages/avatar_selection/avatar_selection_screen.dart';
import 'package:uskudar_mobile/presentation/pages/back_id_scan/screen/back_id_scan_screen.dart';
import 'package:uskudar_mobile/presentation/pages/bank_accounts/bank_accounts_screen.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/bill_payment_screen.dart';
import 'package:uskudar_mobile/presentation/pages/campaign_qr_code/campaign_qr_code_screen.dart';
import 'package:uskudar_mobile/presentation/pages/campaigns/campaigns_screen.dart';
import 'package:uskudar_mobile/presentation/pages/change_email/change_email_screen.dart';
import 'package:uskudar_mobile/presentation/pages/change_password/change_password_screen.dart';
import 'package:uskudar_mobile/presentation/pages/change_phone/change_phone_screen.dart';
import 'package:uskudar_mobile/presentation/pages/commission_rates/commission_rates_screen.dart';
import 'package:uskudar_mobile/presentation/pages/contact_info/contact_info_screen.dart';
import 'package:uskudar_mobile/presentation/pages/customer_coupons/customer_coupons_screen.dart';
import 'package:uskudar_mobile/presentation/pages/customer_demand/customer_demand_screen.dart';
import 'package:uskudar_mobile/presentation/pages/dasboard/dasboard_screen.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_detail/screen/bank_detail_screen.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_list/screen/bank_list_screen.dart';
import 'package:uskudar_mobile/presentation/pages/email_verification/email_verification_screen.dart';
import 'package:uskudar_mobile/presentation/pages/face_scan/screen/face_scan_screen.dart';
import 'package:uskudar_mobile/presentation/pages/faq/faq_screen.dart';
import 'package:uskudar_mobile/presentation/pages/front_id_scan/screen/front_id_scan_screen.dart';
import 'package:uskudar_mobile/presentation/pages/fuel_card_top_up/fuel_card_top_up_screen.dart';
import 'package:uskudar_mobile/presentation/pages/fuel_cards/fuel_cards_screen.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/gift_check_brand_detail_screen.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brands/gift_check_brands_screen.dart';
import 'package:uskudar_mobile/presentation/pages/gift_checks/gift_checks_screen.dart';
import 'package:uskudar_mobile/presentation/pages/home/home_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/screen/country_selection_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/screen/international_money_transfer_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/screen/international_transfer_confirmation_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/screen/international_transfer_result_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/screen/transaction_type_selection_screen.dart';
import 'package:uskudar_mobile/presentation/pages/international_transfer_selection/screen/international_transfer_selection_screen.dart';
import 'package:uskudar_mobile/presentation/pages/iwallet_agreements/iwallet_agreements_screen.dart';
import 'package:uskudar_mobile/presentation/pages/language_selection/language_selection_screen.dart';
import 'package:uskudar_mobile/presentation/pages/merchant_detail/merchant_detail_screen.dart';
import 'package:uskudar_mobile/presentation/pages/metropol/metropol_screen.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_gift_transfer/metropol_gift_transfer_screen.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_locations/metropol_locations_screen.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transactions/metropol_transactions_screen.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transfer/metropol_transfer_screen.dart';
import 'package:uskudar_mobile/presentation/pages/nfc_scan/screen/nfc_scan_screen.dart';
import 'package:uskudar_mobile/presentation/pages/notification/notification_screen.dart';
import 'package:uskudar_mobile/presentation/pages/notification_settings/notification_settings_screen.dart';
import 'package:uskudar_mobile/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:uskudar_mobile/presentation/pages/page_search/page_search_screen.dart';
import 'package:uskudar_mobile/presentation/pages/pending_money_requests/pending_money_requests_screen.dart';
import 'package:uskudar_mobile/presentation/pages/profile/profile_screen.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/display/qr_display_screen.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/generate/qr_generate_screen.dart';
import 'package:uskudar_mobile/presentation/pages/qr_operation/scan/qr_scan_screen.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/screen/receive_money_screen.dart';
import 'package:uskudar_mobile/presentation/pages/registered_users/registered_users_screen.dart';
import 'package:uskudar_mobile/presentation/pages/request_money/request_money_screen.dart';
import 'package:uskudar_mobile/presentation/pages/scoring_questions/scoring_questions_screen.dart';
import 'package:uskudar_mobile/presentation/pages/secret_question/secret_question_screen.dart';
import 'package:uskudar_mobile/presentation/pages/security_change_phone/security_change_phone_screen.dart';
import 'package:uskudar_mobile/presentation/pages/sms_verification/sms_verification_screen.dart';
import 'package:uskudar_mobile/presentation/pages/splash/splash_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transaction_detail/transaction_detail_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transaction_history/transaction_history_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/amount/screen/transfer_amount_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/confirmation/screen/transfer_confirmation_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/method/screen/transfer_method_screen.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/result/screen/transfer_result_screen.dart';
import 'package:uskudar_mobile/presentation/pages/wrong_login_attempts/wrong_login_attempts_screen.dart';
import 'package:uskudar_mobile/presentation/route/route_paths.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
final class AppRouter extends RootStackRouter {
  AppRouter() : super();

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true, path: RoutePaths.splash),
    AutoRoute(
      page: LanguageSelectionRoute.page,
      path: RoutePaths.languageSelection,
    ),
    AutoRoute(page: OnboardingRoute.page, path: RoutePaths.onboarding),
    AutoRoute(page: LoginRoute.page, path: RoutePaths.login),
    AutoRoute(page: SessionExpiredRoute.page, path: RoutePaths.sessionExpired),
    AutoRoute(
      page: AgreementRoute.page,
      path: RoutePaths.agreement,
      fullscreenDialog: true,
    ),
    AutoRoute(page: RegisterRoute.page, path: RoutePaths.register),
    AutoRoute(page: ForgotPasswordRoute.page, path: RoutePaths.forgotPassword),
    AutoRoute(
      page: SecurityForgotPasswordRoute.page,
      path: RoutePaths.securityForgotPassword,
    ),
    AutoRoute(page: ResetPasswordRoute.page, path: RoutePaths.resetPassword),
    AutoRoute(
      page: SmsVerificationRoute.page,
      path: RoutePaths.smsVerification,
    ),
    AutoRoute(
      page: EmailVerificationRoute.page,
      path: RoutePaths.emailVerification,
    ),
    AutoRoute(
      page: AccountVerificationRoute.page,
      path: RoutePaths.accountVerification,
    ),
    AutoRoute(page: SetPasswordRoute.page, path: RoutePaths.setPassword),
    AutoRoute(
      page: PasswordConfirmationRoute.page,
      path: RoutePaths.passwordConfirmation,
    ),
    AutoRoute(
      page: ScoringQuestionsRoute.page,
      path: RoutePaths.scoringQuestions,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: DashboardRoute.page,
      path: RoutePaths.dashboard,
      children: [
        AutoRoute(page: HomeRoute.page, path: RoutePaths.home),
        AutoRoute(
          page: TransactionHistoryRoute.page,
          path: RoutePaths.transactionHistory,
        ),
        AutoRoute(
          page: AlisverislioRoute.page,
          path: RoutePaths.alisverislio,
        ),
        AutoRoute(page: BillPaymentRoute.page, path: RoutePaths.billPayment),
        AutoRoute(
          page: InternationalTransferSelectionRoute.page,
          path: RoutePaths.internationalTransferSelection,
        ),
      ],
    ),
    AutoRoute(page: ProfileRoute.page, path: RoutePaths.profile),
    AutoRoute(
      page: NotificationRoute.page,
      path: RoutePaths.notification,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: RequestMoneyRoute.page,
      path: RoutePaths.requestMoney,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: CommissionRatesRoute.page,
      path: RoutePaths.commissionRates,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: ContactInfoRoute.page,
      path: RoutePaths.contactInfo,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: FaqRoute.page,
      path: RoutePaths.faq,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: AgreementsRoute.page,
      path: RoutePaths.agreements,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: AccountLimitsRoute.page,
      path: RoutePaths.accountLimits,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: NotificationSettingsRoute.page,
      path: RoutePaths.notificationSettings,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: ChangePasswordRoute.page,
      path: RoutePaths.changePassword,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: ChangeEmailRoute.page,
      path: RoutePaths.changeEmail,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: QrGenerateRoute.page,
      path: RoutePaths.qrGenerate,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: QrDisplayRoute.page,
      path: RoutePaths.qrDisplay,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: QrScanRoute.page,
      path: RoutePaths.qrScan,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: BankAccountsRoute.page,
      path: RoutePaths.bankAccounts,
      fullscreenDialog: true,
    ),
    AutoRoute(page: AddBankAccountRoute.page, path: RoutePaths.addBankAccount),
    AutoRoute(
      page: PendingMoneyRequestsRoute.page,
      path: RoutePaths.pendingMoneyRequests,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: TransferMethodRoute.page,
      path: RoutePaths.transferMethod,
      fullscreenDialog: true,
    ),
    AutoRoute(page: TransferAmountRoute.page, path: RoutePaths.transferAmount),
    AutoRoute(
      page: TransferConfirmationRoute.page,
      path: RoutePaths.transferConfirmation,
    ),
    AutoRoute(
      page: TransferResultRoute.page,
      path: RoutePaths.transferResult,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: TransactionDetailRoute.page,
      path: RoutePaths.transactionDetail,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: BankListRoute.page,
      path: RoutePaths.bankList,
      fullscreenDialog: true,
    ),
    AutoRoute(page: BankDetailRoute.page, path: RoutePaths.bankDetail),
    AutoRoute(page: ChangePhoneRoute.page, path: RoutePaths.changePhone),
    AutoRoute(
      page: SecurityChangePhoneRoute.page,
      path: RoutePaths.securityChangePhone,
      fullscreenDialog: true,
    ),
    AutoRoute(page: FrontIdScanRoute.page, path: RoutePaths.idFrontScan),
    AutoRoute(page: BackIdScanRoute.page, path: RoutePaths.idBackScan),
    AutoRoute(page: NfcScanRoute.page, path: RoutePaths.idNfcScan),
    AutoRoute(page: FaceScanRoute.page, path: RoutePaths.faceScan),
    // AutoRoute(
    //   page: AddressConfirmationRoute.page,
    //   path: RoutePaths.addressConfirmation,
    //   fullscreenDialog: true,
    // ),
    AutoRoute(
      page: AddressPreviewRoute.page,
      path: RoutePaths.addressPreview,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: CampaignsRoute.page,
      path: RoutePaths.campaigns,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: MerchantDetailRoute.page,
      path: RoutePaths.merchantDetail,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: CampaignQrCodeRoute.page,
      path: RoutePaths.campaignQrCode,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: IWalletAgreementsRoute.page,
      path: RoutePaths.iwalletAgreements,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: WrongLoginAttemptsRoute.page,
      path: RoutePaths.wrongLoginAttempts,
    ),
    AutoRoute(
      page: AdminRoute.page,
      path: RoutePaths.admin,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: RouteSearchRoute.page,
      path: RoutePaths.pageSearch,
      fullscreenDialog: true,
    ),

    AutoRoute(
      page: CountrySelectionRoute.page,
      path: '/${RoutePaths.countrySelection}',
    ),
    AutoRoute(
      page: ReceiveMoneyRoute.page,
      path: RoutePaths.receiveMoney,
    ),
    AutoRoute(
      page: TransactionTypeSelectionRoute.page,
      path: RoutePaths.transactionTypeSelection,
    ),
    AutoRoute(
      page: InternationalMoneyTransferRoute.page,
      path: RoutePaths.internationalMoneyTransfer,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: InternationalTransferConfirmationRoute.page,
      path: RoutePaths.internationalTransferConfirmation,
    ),
    AutoRoute(
      page: InternationalTransferResultRoute.page,
      path: RoutePaths.internationalTransferResult,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: SecretQuestionRoute.page,
      path: RoutePaths.secretQuestion,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: AvatarSelectionRoute.page,
      path: RoutePaths.avatarSelection,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: CustomerDemandRoute.page,
      path: RoutePaths.customerDemand,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: RegisteredUsersRoute.page,
      path: RoutePaths.registeredUsers,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: GiftChecksRoute.page,
      path: RoutePaths.giftChecks,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: GiftCheckBrandsRoute.page,
      path: RoutePaths.giftCheckBrands,
    ),
    AutoRoute(
      page: GiftCheckBrandDetailRoute.page,
      path: RoutePaths.giftCheckBrandDetail,
    ),
    AutoRoute(
      page: CustomerCouponsRoute.page,
      path: RoutePaths.customerCoupons,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: MetropolRoute.page,
      path: RoutePaths.metropol,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: MetropolLocationsRoute.page,
      path: RoutePaths.metropolLocations,
    ),
    AutoRoute(
      page: MetropolTransactionsRoute.page,
      path: RoutePaths.metropolTransactions,
    ),
    AutoRoute(
      page: MetropolTransferRoute.page,
      path: RoutePaths.metropolTransfer,
    ),
    AutoRoute(
      page: MetropolGiftTransferRoute.page,
      path: RoutePaths.metropolGiftTransfer,
    ),
    AutoRoute(
      page: FuelCardsRoute.page,
      path: RoutePaths.fuelCards,
      fullscreenDialog: true,
    ),
    AutoRoute(
      page: AddFuelCardRoute.page,
      path: RoutePaths.addFuelCard,
    ),
    AutoRoute(
      page: FuelCardTopUpRoute.page,
      path: RoutePaths.fuelCardTopUp,
    ),
  ];
}
