import 'package:get_it/get_it.dart';
import 'package:payinall/di/di_module.dart';
import 'package:payinall/domain/usecases/address_number_inquiry_usecase.dart';
import 'package:payinall/domain/usecases/auth_merchant_usecase.dart';
import 'package:payinall/domain/usecases/auth_mobile_usecase.dart';
import 'package:payinall/domain/usecases/back_image_check_usecase.dart';
import 'package:payinall/domain/usecases/bill_payment_usecase.dart';
import 'package:payinall/domain/usecases/cash_payout_send_transfer_usecase.dart';
import 'package:payinall/domain/usecases/change_notification_usecase.dart';
import 'package:payinall/domain/usecases/change_password_usecase.dart';
import 'package:payinall/domain/usecases/change_phone_code_usecase.dart';
import 'package:payinall/domain/usecases/change_phone_usecase.dart';
import 'package:payinall/domain/usecases/check_activation_code_usecase.dart';
import 'package:payinall/domain/usecases/check_merchant_activation_code_usecase.dart';
import 'package:payinall/domain/usecases/check_register_code_usecase.dart';
import 'package:payinall/domain/usecases/clear_all_notifications_usecase.dart';
import 'package:payinall/domain/usecases/confirm_international_transfer_usecase.dart';
import 'package:payinall/domain/usecases/create_card_usecase.dart';
import 'package:payinall/domain/usecases/create_customer_demand_usecase.dart';
import 'package:payinall/domain/usecases/create_qr_code_usecase.dart';
import 'package:payinall/domain/usecases/create_register_code_usecase.dart';
import 'package:payinall/domain/usecases/customer_bank_usecase.dart';
import 'package:payinall/domain/usecases/customer_merchant_bank_usecase.dart';
import 'package:payinall/domain/usecases/customer_mobiles_usecase.dart';
import 'package:payinall/domain/usecases/delete_customer_avatar_usecase.dart';
import 'package:payinall/domain/usecases/delete_customer_bank_usecase.dart';
import 'package:payinall/domain/usecases/add_frequent_iban_usecase.dart';
import 'package:payinall/domain/usecases/add_frequently_sent_usecase.dart';
import 'package:payinall/domain/usecases/delete_frequent_iban_usecase.dart';
import 'package:payinall/domain/usecases/delete_frequently_sent_usecase.dart';
import 'package:payinall/domain/usecases/get_frequent_ibans_usecase.dart';
import 'package:payinall/domain/usecases/get_frequently_sents_usecase.dart';
import 'package:payinall/domain/usecases/create_fuel_card_usecase.dart';
import 'package:payinall/domain/usecases/get_fuel_cards_usecase.dart';
import 'package:payinall/domain/usecases/delete_fuel_card_usecase.dart';
import 'package:payinall/domain/usecases/fuel_card_top_up_usecase.dart';
import 'package:payinall/domain/usecases/get_fuel_card_balance_usecase.dart';
import 'package:payinall/domain/usecases/delete_notification_usecase.dart';
import 'package:payinall/domain/usecases/delete_request_money_usecase.dart';
import 'package:payinall/domain/usecases/email_verification_confirm_usecase.dart';
import 'package:payinall/domain/usecases/email_verification_send_code_usecase.dart';
import 'package:payinall/domain/usecases/face_image_check_usecase.dart';
import 'package:payinall/domain/usecases/forgot_change_password_usecase.dart';
import 'package:payinall/domain/usecases/forgot_password_usecase.dart';
import 'package:payinall/domain/usecases/front_image_check_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_commission_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_deposit_transfer_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_merchant_count_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_user_count_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_wallet_transfer_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_admin_withdraw_transfer_summary_usecase.dart';
import 'package:payinall/domain/usecases/get_app_banks_usecase.dart';
import 'package:payinall/domain/usecases/get_avatar_images_usecase.dart';
import 'package:payinall/domain/usecases/get_average_revenue_types_usecase.dart';
import 'package:payinall/domain/usecases/get_bic_bank_list_usecase.dart';
import 'package:payinall/domain/usecases/get_bill_inquiry_usecase.dart';
import 'package:payinall/domain/usecases/get_buyer_request_moneys_usecase.dart';
import 'package:payinall/domain/usecases/get_cache_product_list_usecase.dart';
import 'package:payinall/domain/usecases/get_campaigns_usecase.dart';
import 'package:payinall/domain/usecases/get_card_bin_code_usecase.dart';
import 'package:payinall/domain/usecases/get_commissions_active_list_usecase.dart';
import 'package:payinall/domain/usecases/get_contract_by_contract_code_usecase.dart';
import 'package:payinall/domain/usecases/get_contracts_usecase.dart';
import 'package:payinall/domain/usecases/get_country_list_usecase.dart';
import 'package:payinall/domain/usecases/get_country_transaction_type_usecase.dart';
import 'package:payinall/domain/usecases/get_current_customer_wrong_password_histories_usecase.dart';
import 'package:payinall/domain/usecases/get_current_user_info_usecase.dart';
import 'package:payinall/domain/usecases/get_customer_banks_usecase.dart';
import 'package:payinall/domain/usecases/get_customer_demand_subject_types_usecase.dart';
import 'package:payinall/domain/usecases/get_customer_process_list_usecase.dart';
import 'package:payinall/domain/usecases/coupon_take_usecase.dart';
import 'package:payinall/domain/usecases/get_customer_coupons_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_brand_detail_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_brands_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_categories_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_coupons_usecase.dart';
import 'package:payinall/domain/usecases/get_helps_usecase.dart';
import 'package:payinall/domain/usecases/get_metropol_cities_usecase.dart';
import 'package:payinall/domain/usecases/get_point_of_sale_location_list_usecase.dart';
import 'package:payinall/domain/usecases/get_point_of_sale_location_filter_list_usecase.dart';
import 'package:payinall/domain/usecases/create_metropol_user_or_detail_usecase.dart';
import 'package:payinall/domain/usecases/get_metropol_user_balance_usecase.dart';
import 'package:payinall/domain/usecases/get_metropol_transaction_list_usecase.dart';
import 'package:payinall/domain/usecases/metropol_transfer_usecase.dart';
import 'package:payinall/domain/usecases/metropol_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/metropol_gift_transfer_usecase.dart';
import 'package:payinall/domain/usecases/metropol_draw_back_transfer_usecase.dart';
import 'package:payinall/domain/usecases/get_is_first_run_usecase.dart';
import 'package:payinall/domain/usecases/get_iwallet_agreements_usecase.dart';
import 'package:payinall/domain/usecases/get_last_login_usecase.dart';
import 'package:payinall/domain/usecases/get_last_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_logged_in_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_commissions_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_last_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_process_list_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_user_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_merchant_wallet_usecase.dart';
import 'package:payinall/domain/usecases/get_monthly_transaction_count_types_usecase.dart';
import 'package:payinall/domain/usecases/get_notifications_usecase.dart';
import 'package:payinall/domain/usecases/get_offices_usecase.dart';
import 'package:payinall/domain/usecases/get_product_query_definition_usecase.dart';
import 'package:payinall/domain/usecases/get_product_types_usecase.dart';
import 'package:payinall/domain/usecases/get_products_usecase.dart';
import 'package:payinall/domain/usecases/get_question_name_usecase.dart';
import 'package:payinall/domain/usecases/get_required_attributes_usecase.dart';
import 'package:payinall/domain/usecases/get_score_operations_usecase.dart';
import 'package:payinall/domain/usecases/get_sender_request_moneys_usecase.dart';
import 'package:payinall/domain/usecases/get_transaction_receipt_usecase.dart';
import 'package:payinall/domain/usecases/get_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_transfer_info_usecase.dart';
import 'package:payinall/domain/usecases/get_user_address_information_usecase.dart';
import 'package:payinall/domain/usecases/get_user_questions_usecase.dart';
import 'package:payinall/domain/usecases/get_wallet_operator_usecase.dart';
import 'package:payinall/domain/usecases/get_wallet_usecase.dart';
import 'package:payinall/domain/usecases/logout_usecase.dart';
import 'package:payinall/domain/usecases/merchant_transfer_usecase.dart';
import 'package:payinall/domain/usecases/merchant_user_forgot_change_password_usecase.dart';
import 'package:payinall/domain/usecases/merchant_user_forgot_password_usecase.dart';
import 'package:payinall/domain/usecases/merchant_withdraw_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/nfc_check_usecase.dart';
import 'package:payinall/domain/usecases/register_usecase.dart';
import 'package:payinall/domain/usecases/remove_usecase.dart';
import 'package:payinall/domain/usecases/request_money_usecase.dart';
import 'package:payinall/domain/usecases/save_logged_in_usecase.dart';
import 'package:payinall/domain/usecases/save_notification_usecase.dart';
import 'package:payinall/domain/usecases/select_customer_avatar_usecase.dart';
import 'package:payinall/domain/usecases/send_new_code_usecase.dart';
import 'package:payinall/domain/usecases/update_email_confirm_usecase.dart';
import 'package:payinall/domain/usecases/update_email_send_code_usecase.dart';
import 'package:payinall/domain/usecases/update_secret_question_usecase.dart';
import 'package:payinall/domain/usecases/user_address_information_approve_usecase.dart';
import 'package:payinall/domain/usecases/user_score_calculate_usecase.dart';
import 'package:payinall/domain/usecases/wallet_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/wallet_transfer_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_merchant_transfer_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_transfer_complete_usecase.dart';
import 'package:payinall/domain/usecases/withdraw_transfer_usecase.dart';

final class UseCaseModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<GetIsFirstRunUsecase>(GetIsFirstRunUsecase(getIt()))
      ..registerSingleton<GetLoggedInUsecase>(GetLoggedInUsecase(getIt()))
      ..registerLazySingleton<LogoutUsecase>(
        () => LogoutUsecase(getIt(), getIt(), getIt()),
      )
      ..registerLazySingleton<AuthMobileUsecase>(
        () => AuthMobileUsecase(getIt()),
      )
      ..registerLazySingleton<AuthMerchantUsecase>(
        () => AuthMerchantUsecase(getIt()),
      )
      ..registerLazySingleton<ChangeNotificationUsecase>(
        () => ChangeNotificationUsecase(getIt()),
      )
      ..registerLazySingleton<ChangePasswordUsecase>(
        () => ChangePasswordUsecase(getIt()),
      )
      ..registerLazySingleton<ChangePhoneCodeUsecase>(
        () => ChangePhoneCodeUsecase(getIt()),
      )
      ..registerLazySingleton<ChangePhoneUsecase>(
        () => ChangePhoneUsecase(getIt()),
      )
      ..registerLazySingleton<CheckActivationCodeUsecase>(
        () => CheckActivationCodeUsecase(getIt()),
      )
      ..registerLazySingleton<CheckMerchantActivationCodeUsecase>(
        () => CheckMerchantActivationCodeUsecase(getIt()),
      )
      ..registerLazySingleton<CreateRegisterCodeUsecase>(
        () => CreateRegisterCodeUsecase(getIt()),
      )
      ..registerLazySingleton<CheckRegisterCodeUsecase>(
        () => CheckRegisterCodeUsecase(getIt()),
      )
      ..registerLazySingleton<CustomerBankUsecase>(
        () => CustomerBankUsecase(getIt()),
      )
      ..registerLazySingleton<CustomerMerchantBankUsecase>(
        () => CustomerMerchantBankUsecase(getIt()),
      )
      ..registerLazySingleton<CustomerMobilesUsecase>(
        () => CustomerMobilesUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteCustomerBankUsecase>(
        () => DeleteCustomerBankUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteRequestMoneyUsecase>(
        () => DeleteRequestMoneyUsecase(getIt()),
      )
      ..registerLazySingleton<GetAppBanksUsecase>(
        () => GetAppBanksUsecase(getIt()),
      )
      ..registerLazySingleton<BillPaymentUsecase>(
        () => BillPaymentUsecase(getIt()),
      )
      ..registerLazySingleton<GetBillInquiryUsecase>(
        () => GetBillInquiryUsecase(getIt()),
      )
      ..registerLazySingleton<GetProductTypesUsecase>(
        () => GetProductTypesUsecase(getIt()),
      )
      ..registerLazySingleton<GetProductsUsecase>(
        () => GetProductsUsecase(getIt()),
      )
      ..registerLazySingleton<GetProductQueryDefinitionUsecase>(
        () => GetProductQueryDefinitionUsecase(getIt()),
      )
      ..registerLazySingleton<GetCacheProductListUsecase>(
        () => GetCacheProductListUsecase(getIt()),
      )
      ..registerLazySingleton<GetBuyerRequestMoneysUsecase>(
        () => GetBuyerRequestMoneysUsecase(getIt()),
      )
      ..registerLazySingleton<GetCampaignsUsecase>(
        () => GetCampaignsUsecase(getIt()),
      )
      ..registerLazySingleton<GetCommissionsActiveListUsecase>(
        () => GetCommissionsActiveListUsecase(getIt()),
      )
      ..registerLazySingleton<GetMerchantCommissionsUsecase>(
        () => GetMerchantCommissionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetCustomerBanksUsecase>(
        () => GetCustomerBanksUsecase(getIt()),
      )
      ..registerLazySingleton<GetHelpsUsecase>(() => GetHelpsUsecase(getIt()))
      ..registerLazySingleton<GetLastLoginUsecase>(
        () => GetLastLoginUsecase(getIt()),
      )
      ..registerLazySingleton<GetMerchantProcessListUsecase>(
        () => GetMerchantProcessListUsecase(getIt()),
      )
      ..registerLazySingleton<GetScoreOperationsUsecase>(
        () => GetScoreOperationsUsecase(getIt()),
      )
      ..registerLazySingleton<GetSenderRequestMoneysUsecase>(
        () => GetSenderRequestMoneysUsecase(getIt()),
      )
      ..registerLazySingleton<GetTransactionsUsecase>(
        () => GetTransactionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetMerchantUserTransactionsUsecase>(
        () => GetMerchantUserTransactionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetWalletUsecase>(() => GetWalletUsecase(getIt()))
      ..registerLazySingleton<GetMerchantWalletUsecase>(
        () => GetMerchantWalletUsecase(getIt()),
      )
      ..registerLazySingleton<RegisterUsecase>(() => RegisterUsecase(getIt()))
      ..registerLazySingleton<RequestMoneyUsecase>(
        () => RequestMoneyUsecase(getIt()),
      )
      ..registerLazySingleton<SendNewCodeUsecase>(
        () => SendNewCodeUsecase(getIt()),
      )
      ..registerLazySingleton<UserScoreCalculateUsecase>(
        () => UserScoreCalculateUsecase(getIt()),
      )
      ..registerLazySingleton<WalletTransferCompleteUsecase>(
        () => WalletTransferCompleteUsecase(getIt()),
      )
      ..registerLazySingleton<WalletTransferUsecase>(
        () => WalletTransferUsecase(getIt()),
      )
      ..registerLazySingleton<MerchantTransferUsecase>(
        () => MerchantTransferUsecase(getIt()),
      )
      ..registerLazySingleton<WithdrawTransferUsecase>(
        () => WithdrawTransferUsecase(getIt()),
      )
      ..registerLazySingleton<WithdrawMerchantTransferUsecase>(
        () => WithdrawMerchantTransferUsecase(getIt()),
      )
      ..registerLazySingleton<WithdrawTransferCompleteUsecase>(
        () => WithdrawTransferCompleteUsecase(getIt()),
      )
      ..registerLazySingleton<MerchantWithdrawTransferCompleteUsecase>(
        () => MerchantWithdrawTransferCompleteUsecase(getIt()),
      )
      ..registerLazySingleton<SaveLoggedInUsecase>(
        () => SaveLoggedInUsecase(getIt()),
      )
      ..registerLazySingleton<GetCurrentUserInfoUsecase>(
        () => GetCurrentUserInfoUsecase(getIt()),
      )
      ..registerLazySingleton<GetLastTransactionsUsecase>(
        () => GetLastTransactionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetMerchantLastTransactionsUsecase>(
        () => GetMerchantLastTransactionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetContractsUsecase>(
        () => GetContractsUsecase(getIt()),
      )
      ..registerLazySingleton<GetAverageRevenueTypesUsecase>(
        () => GetAverageRevenueTypesUsecase(getIt()),
      )
      ..registerLazySingleton<GetMonthlyTransactionCountTypesUsecase>(
        () => GetMonthlyTransactionCountTypesUsecase(getIt()),
      )
      ..registerLazySingleton<GetTransactionReceiptUsecase>(
        () => GetTransactionReceiptUsecase(getIt()),
      )
      ..registerLazySingleton<GetCustomerProcessListUsecase>(
        () => GetCustomerProcessListUsecase(getIt()),
      )
      ..registerLazySingleton<FrontImageCheckUsecase>(
        () => FrontImageCheckUsecase(getIt()),
      )
      ..registerLazySingleton<BackImageCheckUsecase>(
        () => BackImageCheckUsecase(getIt()),
      )
      ..registerLazySingleton<NfcCheckUsecase>(() => NfcCheckUsecase(getIt()))
      ..registerLazySingleton<FaceImageCheckUsecase>(
        () => FaceImageCheckUsecase(getIt()),
      )
      ..registerLazySingleton<ForgotChangePasswordUsecase>(
        () => ForgotChangePasswordUsecase(getIt()),
      )
      ..registerLazySingleton<MerchantUserForgotChangePasswordUsecase>(
        () => MerchantUserForgotChangePasswordUsecase(getIt()),
      )
      ..registerLazySingleton<MerchantUserForgotPasswordUsecase>(
        () => MerchantUserForgotPasswordUsecase(getIt()),
      )
      ..registerLazySingleton<ForgotPasswordUsecase>(
        () => ForgotPasswordUsecase(getIt()),
      )
      ..registerLazySingleton<GetUserQuestionsUsecase>(
        () => GetUserQuestionsUsecase(getIt()),
      )
      ..registerLazySingleton<GetQuestionNameUsecase>(
        () => GetQuestionNameUsecase(getIt()),
      )
      ..registerLazySingleton<RemoveUsecase>(
        () => RemoveUsecase(getIt(), getIt()),
      )
      ..registerLazySingleton<AddressNumberInquiryUsecase>(
        () => AddressNumberInquiryUsecase(getIt()),
      )
      ..registerLazySingleton<GetContractByContractCodeUsecase>(
        () => GetContractByContractCodeUsecase(getIt()),
      )
      ..registerLazySingleton<GetUserAddressInformationUsecase>(
        () => GetUserAddressInformationUsecase(getIt()),
      )
      ..registerLazySingleton<UserAddressInformationApproveUsecase>(
        () => UserAddressInformationApproveUsecase(getIt()),
      )
      ..registerLazySingleton<GetCurrentCustomerWrongPasswordHistoriesUsecase>(
        () => GetCurrentCustomerWrongPasswordHistoriesUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminUserCountUsecase>(
        () => GetAdminUserCountUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminMerchantCountUsecase>(
        () => GetAdminMerchantCountUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminCommissionSummaryUsecase>(
        () => GetAdminCommissionSummaryUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminWalletTransferSummaryUsecase>(
        () => GetAdminWalletTransferSummaryUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminDepositTransferSummaryUsecase>(
        () => GetAdminDepositTransferSummaryUsecase(getIt()),
      )
      ..registerLazySingleton<GetAdminWithdrawTransferSummaryUsecase>(
        () => GetAdminWithdrawTransferSummaryUsecase(getIt()),
      )
      ..registerSingleton<GetNotificationsUsecase>(
        GetNotificationsUsecase(getIt()),
      )
      ..registerSingleton<SaveNotificationUsecase>(
        SaveNotificationUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteNotificationUsecase>(
        () => DeleteNotificationUsecase(getIt()),
      )
      ..registerLazySingleton<ClearAllNotificationsUsecase>(
        () => ClearAllNotificationsUsecase(getIt()),
      )
      ..registerLazySingleton<CreateCardUsecase>(
        () => CreateCardUsecase(getIt()),
      )
      ..registerLazySingleton<CreateQrCodeUsecase>(
        () => CreateQrCodeUsecase(getIt()),
      )
      ..registerLazySingleton<GetIWalletAgreementsUsecase>(
        () => GetIWalletAgreementsUsecase(getIt()),
      )
      ..registerLazySingleton<GetRequiredAttributesUsecase>(
        () => GetRequiredAttributesUsecase(getIt()),
      )
      ..registerLazySingleton<GetCountryListUsecase>(
        () => GetCountryListUsecase(getIt()),
      )
      ..registerLazySingleton<GetCountryTransactionTypeUsecase>(
        () => GetCountryTransactionTypeUsecase(getIt()),
      )
      ..registerLazySingleton<CashPayoutSendTransferUsecase>(
        () => CashPayoutSendTransferUsecase(getIt()),
      )
      ..registerLazySingleton<ConfirmInternationalTransferUsecase>(
        () => ConfirmInternationalTransferUsecase(getIt()),
      )
      ..registerLazySingleton<GetBicBankListUsecase>(
        () => GetBicBankListUsecase(getIt()),
      )
      ..registerLazySingleton<GetOfficesUsecase>(
        () => GetOfficesUsecase(getIt()),
      )
      ..registerLazySingleton<GetCardBinCodeUsecase>(
        () => GetCardBinCodeUsecase(getIt()),
      )
      ..registerLazySingleton<GetWalletOperatorUsecase>(
        () => GetWalletOperatorUsecase(getIt()),
      )
      ..registerLazySingleton<GetTransferInfoUsecase>(
        () => GetTransferInfoUsecase(getIt()),
      )
      ..registerLazySingleton<GetAvatarImagesUsecase>(
        () => GetAvatarImagesUsecase(getIt()),
      )
      ..registerLazySingleton<SelectCustomerAvatarUsecase>(
        () => SelectCustomerAvatarUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteCustomerAvatarUsecase>(
        () => DeleteCustomerAvatarUsecase(getIt()),
      )
      ..registerLazySingleton<UpdateSecretQuestionUsecase>(
        () => UpdateSecretQuestionUsecase(getIt()),
      )
      ..registerLazySingleton<EmailVerificationSendCodeUsecase>(
        () => EmailVerificationSendCodeUsecase(getIt()),
      )
      ..registerLazySingleton<EmailVerificationConfirmUsecase>(
        () => EmailVerificationConfirmUsecase(getIt()),
      )
      ..registerLazySingleton<UpdateEmailSendCodeUsecase>(
        () => UpdateEmailSendCodeUsecase(getIt()),
      )
      ..registerLazySingleton<UpdateEmailConfirmUsecase>(
        () => UpdateEmailConfirmUsecase(getIt()),
      )
      ..registerLazySingleton<GetCustomerDemandSubjectTypesUsecase>(
        () => GetCustomerDemandSubjectTypesUsecase(getIt()),
      )
      ..registerLazySingleton<CreateCustomerDemandUsecase>(
        () => CreateCustomerDemandUsecase(getIt()),
      )
      ..registerLazySingleton<GetFrequentIbansUsecase>(
        () => GetFrequentIbansUsecase(getIt()),
      )
      ..registerLazySingleton<AddFrequentIbanUsecase>(
        () => AddFrequentIbanUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteFrequentIbanUsecase>(
        () => DeleteFrequentIbanUsecase(getIt()),
      )
      ..registerLazySingleton<AddFrequentlySentUsecase>(
        () => AddFrequentlySentUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteFrequentlySentUsecase>(
        () => DeleteFrequentlySentUsecase(getIt()),
      )
      ..registerLazySingleton<GetFrequentlySentsUsecase>(
        () => GetFrequentlySentsUsecase(getIt()),
      )
      ..registerLazySingleton<GetGiftCheckCategoriesUsecase>(
        () => GetGiftCheckCategoriesUsecase(getIt()),
      )
      ..registerLazySingleton<GetGiftCheckBrandsUsecase>(
        () => GetGiftCheckBrandsUsecase(getIt()),
      )
      ..registerLazySingleton<GetGiftCheckBrandDetailUsecase>(
        () => GetGiftCheckBrandDetailUsecase(getIt()),
      )
      ..registerLazySingleton<GetGiftCheckCouponsUsecase>(
        () => GetGiftCheckCouponsUsecase(getIt()),
      )
      ..registerLazySingleton<CouponTakeUsecase>(
        () => CouponTakeUsecase(getIt()),
      )
      ..registerLazySingleton<GetCustomerCouponsUsecase>(
        () => GetCustomerCouponsUsecase(getIt()),
      )
      ..registerLazySingleton<GetMetropolCitiesUsecase>(
        () => GetMetropolCitiesUsecase(getIt()),
      )
      ..registerLazySingleton<GetPointOfSaleLocationListUsecase>(
        () => GetPointOfSaleLocationListUsecase(getIt()),
      )
      ..registerLazySingleton<GetPointOfSaleLocationFilterListUsecase>(
        () => GetPointOfSaleLocationFilterListUsecase(getIt()),
      )
      ..registerLazySingleton<CreateMetropolUserOrDetailUsecase>(
        () => CreateMetropolUserOrDetailUsecase(getIt()),
      )
      ..registerLazySingleton<GetMetropolUserBalanceUsecase>(
        () => GetMetropolUserBalanceUsecase(getIt()),
      )
      ..registerLazySingleton<GetMetropolTransactionListUsecase>(
        () => GetMetropolTransactionListUsecase(getIt()),
      )
      ..registerLazySingleton<MetropolTransferUsecase>(
        () => MetropolTransferUsecase(getIt()),
      )
      ..registerLazySingleton<MetropolTransferCompleteUsecase>(
        () => MetropolTransferCompleteUsecase(getIt()),
      )
      ..registerLazySingleton<MetropolGiftTransferUsecase>(
        () => MetropolGiftTransferUsecase(getIt()),
      )
      ..registerLazySingleton<MetropolDrawBackTransferUsecase>(
        () => MetropolDrawBackTransferUsecase(getIt()),
      )
      ..registerLazySingleton<CreateFuelCardUsecase>(
        () => CreateFuelCardUsecase(getIt()),
      )
      ..registerLazySingleton<GetFuelCardsUsecase>(
        () => GetFuelCardsUsecase(getIt()),
      )
      ..registerLazySingleton<DeleteFuelCardUsecase>(
        () => DeleteFuelCardUsecase(getIt()),
      )
      ..registerLazySingleton<FuelCardTopUpUsecase>(
        () => FuelCardTopUpUsecase(getIt()),
      )
      ..registerLazySingleton<GetFuelCardBalanceUsecase>(
        () => GetFuelCardBalanceUsecase(getIt()),
      );
  }
}
