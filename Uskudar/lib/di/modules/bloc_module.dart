import 'package:get_it/get_it.dart';
import 'package:payinall/di/di_module.dart';
import 'package:payinall/presentation/pages/account_limits/bloc/account_limits_bloc.dart';
import 'package:payinall/presentation/pages/add_bank_account/bloc/add_bank_account_bloc.dart';
import 'package:payinall/presentation/pages/address_preview/bloc/address_preview_bloc.dart';
import 'package:payinall/presentation/pages/admin/bloc/admin_bloc.dart';
import 'package:payinall/presentation/pages/agreement/bloc/agreement_bloc.dart';
import 'package:payinall/presentation/pages/auth/account_verification/bloc/account_verification_bloc.dart';
import 'package:payinall/presentation/pages/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:payinall/presentation/pages/auth/login/bloc/login_bloc.dart';
import 'package:payinall/presentation/pages/auth/password_confirmation/bloc/password_confirmation_bloc.dart';
import 'package:payinall/presentation/pages/auth/register/bloc/register_bloc.dart';
import 'package:payinall/presentation/pages/auth/reset_password/bloc/reset_password_bloc.dart';
import 'package:payinall/presentation/pages/auth/security_forgot_password/bloc/security_forgot_password_bloc.dart';
import 'package:payinall/presentation/pages/auth/set_password/bloc/set_password_bloc.dart';
import 'package:payinall/presentation/pages/avatar_selection/bloc/avatar_selection_bloc.dart';
import 'package:payinall/presentation/pages/back_id_scan/bloc/back_id_scan_bloc.dart';
import 'package:payinall/presentation/pages/bank_accounts/bloc/bank_accounts_bloc.dart';
import 'package:payinall/presentation/pages/bill_payment/bloc/bill_payment_bloc.dart';
import 'package:payinall/presentation/pages/campaign_qr_code/bloc/campaign_qr_code_bloc.dart';
import 'package:payinall/presentation/pages/campaigns/bloc/campaigns_bloc.dart';
import 'package:payinall/presentation/pages/change_email/bloc/change_email_bloc.dart';
import 'package:payinall/presentation/pages/change_password/bloc/change_password_bloc.dart';
import 'package:payinall/presentation/pages/change_phone/bloc/change_phone_bloc.dart';
import 'package:payinall/presentation/pages/commission_rates/bloc/commission_rates_bloc.dart';
import 'package:payinall/presentation/pages/contact_info/bloc/contact_info_bloc.dart';
import 'package:payinall/presentation/pages/customer_demand/bloc/customer_demand_bloc.dart';
import 'package:payinall/presentation/pages/deposit/bank_detail/bloc/bank_detail_bloc.dart';
import 'package:payinall/presentation/pages/deposit/bank_list/bloc/bank_list_bloc.dart';
import 'package:payinall/presentation/pages/email_verification/bloc/email_verification_bloc.dart';
import 'package:payinall/presentation/pages/face_scan/bloc/face_scan_bloc.dart';
import 'package:payinall/presentation/pages/faq/bloc/faq_bloc.dart';
import 'package:payinall/presentation/pages/fuel_cards/bloc/fuel_cards_bloc.dart';
import 'package:payinall/presentation/pages/add_fuel_card/bloc/add_fuel_card_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/bloc/fuel_card_top_up_bloc.dart';
import 'package:payinall/presentation/pages/customer_coupons/bloc/customer_coupons_bloc.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/bloc/gift_check_brand_detail_bloc.dart';
import 'package:payinall/presentation/pages/gift_check_brands/bloc/gift_check_brands_bloc.dart';
import 'package:payinall/presentation/pages/gift_checks/bloc/gift_checks_bloc.dart';
import 'package:payinall/presentation/pages/front_id_scan/bloc/front_id_scan_bloc.dart';
import 'package:payinall/presentation/pages/metropol/bloc/metropol_bloc.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/pages/metropol_transactions/bloc/metropol_transactions_bloc.dart';
import 'package:payinall/presentation/pages/metropol_transfer/bloc/metropol_transfer_bloc.dart';
import 'package:payinall/presentation/pages/metropol_gift_transfer/bloc/metropol_gift_transfer_bloc.dart';
import 'package:payinall/presentation/pages/home/bloc/home_bloc.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/country_selection_bloc.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/international_money_transfer_bloc.dart';
import 'package:payinall/presentation/pages/iwallet_agreements/bloc/iwallet_agreements_bloc.dart';
import 'package:payinall/presentation/pages/merchant_detail/bloc/merchant_detail_bloc.dart';
import 'package:payinall/presentation/pages/nfc_scan/bloc/nfc_scan_bloc.dart';
import 'package:payinall/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:payinall/presentation/pages/notification_settings/bloc/notification_settings_bloc.dart';
import 'package:payinall/presentation/pages/onboarding/bloc/onboarding_bloc.dart';
import 'package:payinall/presentation/pages/page_search/bloc/page_search_bloc.dart';
import 'package:payinall/presentation/pages/pending_money_requests/bloc/pending_money_requests_bloc.dart';
import 'package:payinall/presentation/pages/profile/bloc/profile_bloc.dart';
import 'package:payinall/presentation/pages/qr_operation/display/bloc/qr_display_bloc.dart';
import 'package:payinall/presentation/pages/qr_operation/generate/bloc/qr_generate_bloc.dart';
import 'package:payinall/presentation/pages/qr_operation/scan/bloc/qr_scan_bloc.dart';
import 'package:payinall/presentation/pages/receive_money/bloc/receive_money_bloc.dart';
import 'package:payinall/presentation/pages/registered_users/bloc/registered_users_bloc.dart';
import 'package:payinall/presentation/pages/request_money/bloc/request_money_bloc.dart';
import 'package:payinall/presentation/pages/scoring_questions/bloc/scoring_questions_bloc.dart';
import 'package:payinall/presentation/pages/secret_question/bloc/secret_question_bloc.dart';
import 'package:payinall/presentation/pages/security_change_phone/bloc/security_change_phone_bloc.dart';
import 'package:payinall/presentation/pages/sms_verification/bloc/sms_verification_bloc.dart';
import 'package:payinall/presentation/pages/splash/bloc/splash_bloc.dart';
import 'package:payinall/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:payinall/presentation/pages/transaction_history/bloc/transaction_history_bloc.dart';
import 'package:payinall/presentation/pages/transfer/amount/bloc/transfer_amount_bloc.dart';
import 'package:payinall/presentation/pages/transfer/confirmation/bloc/transfer_confirmation_bloc.dart';
import 'package:payinall/presentation/pages/transfer/method/bloc/transfer_method_bloc.dart';
import 'package:payinall/presentation/pages/transfer/result/bloc/transfer_result_bloc.dart';
import 'package:payinall/presentation/pages/wrong_login_attempts/bloc/wrong_login_attempts_bloc.dart';

final class BlocModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerFactory<SplashBloc>(
        () => SplashBloc(
          firebaseService: getIt(),
          getIsFirstRunUsecase: getIt(),
          getLoggedInUsecase: getIt(),
          getContractsUsecase: getIt(),
          rootCheckService: getIt(),
        ),
      )
      ..registerFactory<OnboardingBloc>(OnboardingBloc.new)
      ..registerFactory<LoginBloc>(
        () => LoginBloc(
          authMobileUsecase: getIt(),
          authMerchantUsecase: getIt(),
          deviceInfoService: getIt(),
          saveLoggedInUsecase: getIt(),
          customerMobilesUsecase: getIt(),
          firebaseService: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<RegisterBloc>(
        () => RegisterBloc(createRegisterCodeUsecase: getIt()),
      )
      ..registerFactory<SmsVerificationBloc>(
        () => SmsVerificationBloc(
          checkRegisterCodeUsecase: getIt(),
          createRegisterCodeUsecase: getIt(),
          checkActivationCodeUsecase: getIt(),
          checkMerchantActivationCodeUsecase: getIt(),
          sendNewCodeUsecase: getIt(),
          changePhoneUsecase: getIt(),
          userInfoManager: getIt(),
          changePhoneCodeUsecase: getIt(),
          logoutUsecase: getIt(),
          customerMobilesUsecase: getIt(),
          deviceInfoService: getIt(),
          firebaseService: getIt(),
        ),
      )
      ..registerFactory<EmailVerificationBloc>(
        () => EmailVerificationBloc(
          emailVerificationSendCodeUsecase: getIt(),
          emailVerificationConfirmUsecase: getIt(),
          updateEmailSendCodeUsecase: getIt(),
          updateEmailConfirmUsecase: getIt(),
        ),
      )
      ..registerFactory<ForgotPasswordBloc>(
        () => ForgotPasswordBloc(forgotPasswordUsecase: getIt()),
      )
      ..registerFactory<SecurityForgotPasswordBloc>(
        () => SecurityForgotPasswordBloc(
          getQuestionNameUsecase: getIt(),
          merchantUserForgotPasswordUsecase: getIt(),
        ),
      )
      ..registerFactory<ResetPasswordBloc>(
        () => ResetPasswordBloc(
          forgotChangePasswordUsecase: getIt(),
          merchantUserForgotChangePasswordUsecase: getIt(),
        ),
      )
      ..registerFactory<AccountVerificationBloc>(
        () => AccountVerificationBloc(getUserQuestionsUsecase: getIt()),
      )
      ..registerFactory<SetPasswordBloc>(
        () => SetPasswordBloc(registerUsecase: getIt()),
      )
      ..registerFactory<PasswordConfirmationBloc>(
        () => PasswordConfirmationBloc(
          logoutUsecase: getIt(),
          authMobileUsecase: getIt(),
          deviceInfoService: getIt(),
          customerMobilesUsecase: getIt(),
          firebaseService: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<AgreementBloc>(
        () => AgreementBloc(getContractByContractCodeUsecase: getIt()),
      )
      ..registerSingleton<HomeBloc>(
        HomeBloc(
          getCurrentUserInfoUsecase: getIt(),
          getLastTransactionsUsecase: getIt(),
          getMerchantLastTransactionsUsecase: getIt(),
          getWalletUsecase: getIt(),
          getMerchantWalletUsecase: getIt(),
          getFrequentIbansUsecase: getIt(),
          getFrequentlySentsUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<RequestMoneyBloc>(
        () => RequestMoneyBloc(requestMoneyUsecase: getIt()),
      )
      ..registerFactory<TransactionHistoryBloc>(
        () => TransactionHistoryBloc(
          getTransactionsUsecase: getIt(),
          getMerchantUserTransactionsUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<NotificationBloc>(
        () => NotificationBloc(
          getNotificationsUsecase: getIt(),
          deleteNotificationUsecase: getIt(),
          clearAllNotificationsUsecase: getIt(),
        ),
      )
      ..registerFactory<PageSearchBloc>(
        () => PageSearchBloc(
          getCacheProductListUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<QrGenerateBloc>(
        () => QrGenerateBloc(qrCodeService: getIt()),
      )
      ..registerFactory<QrDisplayBloc>(QrDisplayBloc.new)
      ..registerFactory<QrScanBloc>(
        () => QrScanBloc(qrCodeService: getIt(), permissionService: getIt()),
      )
      ..registerFactory<ProfileBloc>(
        () => ProfileBloc(
          userInfoManager: getIt(),
          getCurrentUserInfoUsecase: getIt(),
          getWalletUsecase: getIt(),
          logoutUsecase: getIt(),
          removeUsecase: getIt(),
          emailVerificationSendCodeUsecase: getIt(),
        ),
      )
      ..registerFactory<CommissionRatesBloc>(
        () => CommissionRatesBloc(
          getCommissionsActiveListUsecase: getIt(),
          getMerchantCommissionsUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<ContactInfoBloc>(ContactInfoBloc.new)
      ..registerFactory<CustomerDemandBloc>(
        () => CustomerDemandBloc(
          getCustomerDemandSubjectTypesUsecase: getIt(),
          createCustomerDemandUsecase: getIt(),
        ),
      )
      ..registerFactory<FaqBloc>(() => FaqBloc(getHelpsUsecase: getIt()))
      ..registerFactory<AccountLimitsBloc>(
        () => AccountLimitsBloc(
          getCustomerProcessListUsecase: getIt(),
          getMerchantProcessListUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<NotificationSettingsBloc>(
        () => NotificationSettingsBloc(
          changeNotificationUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<ChangePasswordBloc>(
        () => ChangePasswordBloc(
          changePasswordUsecase: getIt(),
          logOutUsecase: getIt(),
        ),
      )
      ..registerFactory<ChangeEmailBloc>(
        () => ChangeEmailBloc(
          updateEmailSendCodeUsecase: getIt(),
        ),
      )
      ..registerFactory<AddBankAccountBloc>(
        () => AddBankAccountBloc(
          customerBankUsecase: getIt(),
          customerMerchantBankUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<BankAccountsBloc>(
        () => BankAccountsBloc(
          getCustomerBanksUsecase: getIt(),
          deleteCustomerBankUsecase: getIt(),
        ),
      )
      ..registerLazySingleton<BillPaymentBloc>(
        () => BillPaymentBloc(
          getProductTypesUsecase: getIt(),
          getProductsUsecase: getIt(),
          getProductQueryDefinitionUsecase: getIt(),
          getBillInquiryUsecase: getIt(),
          billPaymentUsecase: getIt(),
          getCacheProductListUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<CampaignsBloc>(
        () => CampaignsBloc(getCampaignsUsecase: getIt()),
      )
      ..registerFactory<CampaignQrCodeBloc>(
        () => CampaignQrCodeBloc(createQrCodeUsecase: getIt()),
      )
      ..registerFactory<PendingMoneyRequestsBloc>(
        () => PendingMoneyRequestsBloc(
          getBuyerRequestMoneysUsecase: getIt(),
          getSenderRequestMoneysUsecase: getIt(),
          deleteRequestMoneyUsecase: getIt(),
          walletTransferUsecase: getIt(),
        ),
      )
      ..registerFactory<TransferMethodBloc>(
        () => TransferMethodBloc(
          getCustomerBanksUsecase: getIt(),
          getFrequentlySentsUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<ScoringQuestionsBloc>(
        () => ScoringQuestionsBloc(
          getAverageRevenueTypesUsecase: getIt(),
          getMonthlyTransactionCountTypesUsecase: getIt(),
          getScoreOperationsUsecase: getIt(),
          userScoreCalculateUsecase: getIt(),
        ),
      )
      ..registerFactory<TransferAmountBloc>(
        () => TransferAmountBloc(
          merchantTransferUsecase: getIt(),
          walletTransferUsecase: getIt(),
          withdrawTransferUsecase: getIt(),
          withdrawMerchantTransferUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<TransferConfirmationBloc>(
        () => TransferConfirmationBloc(
          walletTransferCompleteUsecase: getIt(),
          withdrawTransferCompleteUsecase: getIt(),
          merchantWithdrawTransferCompleteUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<TransferResultBloc>(
        () => TransferResultBloc(getTransactionReceiptUsecase: getIt()),
      )
      ..registerFactory<BankListBloc>(
        () => BankListBloc(getAppBanksUsecase: getIt()),
      )
      ..registerFactory<BankDetailBloc>(
        () => BankDetailBloc(userInfoManager: getIt()),
      )
      ..registerFactory(() => ChangePhoneBloc(changePhoneCodeUsecase: getIt()))
      ..registerFactory<FaceScanBloc>(
        () => FaceScanBloc(faceImageCheckUsecase: getIt()),
      )
      ..registerFactory<FrontIdScanBloc>(
        () => FrontIdScanBloc(frontImageCheckUsecase: getIt()),
      )
      ..registerFactory<BackIdScanBloc>(
        () => BackIdScanBloc(backImageCheckUsecase: getIt()),
      )
      ..registerFactory<NfcScanBloc>(
        () => NfcScanBloc(nfcCheckUsecase: getIt()),
      )
      ..registerFactory<TransactionDetailBloc>(
        () => TransactionDetailBloc(getTransactionReceiptUsecase: getIt()),
      )
      // ..registerFactory<AddressConfirmationBloc>(
      //   () => AddressConfirmationBloc(addressNumberInquiryUsecase: getIt()),
      // )
      ..registerFactory<AddressPreviewBloc>(
        () => AddressPreviewBloc(
          getUserAddressInformationUsecase: getIt(),
          userAddressInformationApproveUsecase: getIt(),
        ),
      )
      ..registerFactory<SecurityChangePhoneBloc>(
        () => SecurityChangePhoneBloc(getQuestionNameUsecase: getIt()),
      )
      ..registerFactory<WrongLoginAttemptsBloc>(
        () => WrongLoginAttemptsBloc(
          getCurrentCustomerWrongPasswordHistoriesUsecase: getIt(),
        ),
      )
      ..registerFactory<AdminBloc>(
        () => AdminBloc(
          getAdminUserCountUsecase: getIt(),
          getAdminMerchantCountUsecase: getIt(),
          getAdminCommissionSummaryUsecase: getIt(),
          getAdminWalletTransferSummaryUsecase: getIt(),
          getAdminDepositTransferSummaryUsecase: getIt(),
          getAdminWithdrawTransferSummaryUsecase: getIt(),
        ),
      )
      ..registerFactory<MerchantDetailBloc>(
        () => MerchantDetailBloc(
          createCardUsecase: getIt(),
          createQrCodeUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<IWalletAgreementsBloc>(
        () => IWalletAgreementsBloc(
          getIWalletAgreementsUsecase: getIt(),
        ),
      )
      ..registerFactory<InternationalMoneyTransferBloc>(
        () => InternationalMoneyTransferBloc(
          getRequiredAttributesUsecase: getIt(),
          cashPayoutSendTransferUsecase: getIt(),
          confirmInternationalTransferUsecase: getIt(),
          getBicBankListUsecase: getIt(),
          getOfficesUsecase: getIt(),
          getCardBinCodeUsecase: getIt(),
          getWalletOperatorUsecase: getIt(),
        ),
      )
      ..registerFactory<CountrySelectionBloc>(
        () => CountrySelectionBloc(
          getCountryListUsecase: getIt(),
          getCountryTransactionTypeUsecase: getIt(),
        ),
      )
      ..registerFactory<SecretQuestionBloc>(
        () => SecretQuestionBloc(
          getUserQuestionsUsecase: getIt(),
          updateSecretQuestionUsecase: getIt(),
        ),
      )
      ..registerFactory<ReceiveMoneyBloc>(
        () => ReceiveMoneyBloc(getTransferInfoUsecase: getIt()),
      )
      ..registerFactory<AvatarSelectionBloc>(
        () => AvatarSelectionBloc(
          getAvatarImagesUsecase: getIt(),
          selectCustomerAvatarUsecase: getIt(),
          deleteCustomerAvatarUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<RegisteredUsersBloc>(
        () => RegisteredUsersBloc(
          addFrequentlySentUsecase: getIt(),
          deleteFrequentlySentUsecase: getIt(),
          getFrequentlySentsUsecase: getIt(),
          getFrequentIbansUsecase: getIt(),
          addFrequentIbanUsecase: getIt(),
          deleteFrequentIbanUsecase: getIt(),
          userInfoManager: getIt(),
        ),
      )
      ..registerFactory<GiftChecksBloc>(
        () => GiftChecksBloc(
          getGiftCheckCategoriesUsecase: getIt(),
        ),
      )
      ..registerFactory<GiftCheckBrandsBloc>(
        () => GiftCheckBrandsBloc(
          getGiftCheckBrandsUsecase: getIt(),
        ),
      )
      ..registerFactory<GiftCheckBrandDetailBloc>(
        () => GiftCheckBrandDetailBloc(
          getGiftCheckBrandDetailUsecase: getIt(),
          getGiftCheckCouponsUsecase: getIt(),
          couponTakeUsecase: getIt(),
        ),
      )
      ..registerFactory<CustomerCouponsBloc>(
        () => CustomerCouponsBloc(
          getCustomerCouponsUsecase: getIt(),
        ),
      )
      ..registerFactory<MetropolBloc>(
        () => MetropolBloc(
          createMetropolUserOrDetailUsecase: getIt(),
          getMetropolUserBalanceUsecase: getIt(),
        ),
      )
      ..registerFactory<MetropolLocationsBloc>(
        () => MetropolLocationsBloc(
          getMetropolCitiesUsecase: getIt(),
          getPointOfSaleLocationListUsecase: getIt(),
          getPointOfSaleLocationFilterListUsecase: getIt(),
        ),
      )
      ..registerFactory<MetropolTransactionsBloc>(
        () => MetropolTransactionsBloc(
          getMetropolTransactionListUsecase: getIt(),
        ),
      )
      ..registerFactory<MetropolTransferBloc>(
        () => MetropolTransferBloc(
          metropolTransferUsecase: getIt(),
          metropolTransferCompleteUsecase: getIt(),
          metropolDrawBackTransferUsecase: getIt(),
        ),
      )
      ..registerFactory<MetropolGiftTransferBloc>(
        () => MetropolGiftTransferBloc(
          metropolGiftTransferUsecase: getIt(),
          metropolDrawBackTransferUsecase: getIt(),
        ),
      )
      ..registerFactory<FuelCardsBloc>(
        () => FuelCardsBloc(
          getFuelCardsUsecase: getIt(),
          deleteFuelCardUsecase: getIt(),
          getFuelCardBalanceUsecase: getIt(),
        ),
      )
      ..registerFactory<AddFuelCardBloc>(
        () => AddFuelCardBloc(
          createFuelCardUsecase: getIt(),
        ),
      )
      ..registerFactory<FuelCardTopUpBloc>(
        () => FuelCardTopUpBloc(
          fuelCardTopUpUsecase: getIt(),
          getFuelCardBalanceUsecase: getIt(),
        ),
      );
  }
}
