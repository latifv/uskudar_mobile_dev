final class Endpoints {
  const Endpoints._();

  static const String auth = '/Auth';
  static const String authMobile = '$auth/authMobile';
  static const String authMerchant = '$auth/authMerchant';

  static const String customerActivations = '/CustomerActivations';
  static const String sendNewCode = '$customerActivations/sendNewCode';
  static const String checkActivationCode =
      '$customerActivations/checkActivationCode';
  static const String checkMerchantActivationCode =
      '$customerActivations/checkMerchantActivationCode';

  static const String customerRegisterCode = '/CustomerRegisterCode';
  static const String createRegisterCode =
      '$customerRegisterCode/createRegisterCode';
  static const String checkRegisterCode =
      '$customerRegisterCode/checkRegisterCode';

  static const String users = '/Users';
  static const String register = '$users/register';
  static const String currentUserInfo = '$users/getCurrentUserInfo';
  static String changeNotification(int notificationTypeId) =>
      '$users/changeNotification/$notificationTypeId';
  static const String remove = '$users/remove';
  static const String updateSecretQuestion = '$users/updateSecretQuestion';
  static const String emailVerificationSendCode =
      '$users/emailVerificationSendCode';
  static const String emailVerificationConfirm =
      '$users/emailVerifcationConfirm';
  static const String updateEmailSendCode = '$users/updateEmailSendCode';
  static const String updateEmailConfirm = '$users/updateEmailConfirm';

  static const String commissions = '/Commissions';
  static const String commissionsGetActiveList = '$commissions/getActiveList';
  static const String getMerchantCommissions =
      '$commissions/getMerchantCommissions';

  static const String loginAttempts = '/LoginAttempts';
  static const String getLastLogin = '$loginAttempts/getLastLogin';

  static const String customerMobiles = '/CustomerMobiles';

  static const String passwords = '/Passwords';
  static const String changePassword = '$passwords/changePassword';
  static String getQuestionName(String identityNumber) =>
      '$passwords/getQuestionName/$identityNumber';
  static const String forgotPassword = '$passwords/forgotPassword';
  static const String forgotChangePassword = '$passwords/forgotChangePassword';
  static const String merchantUserForgotPassword =
      '$passwords/merchantUserForgotPassword';
  static const String merchantUserForgotChangePassword =
      '$passwords/merchantUserForgotChangePassword';

  static const String appBanks = '/AppBanks';
  static const String appBanksGetActives = '$appBanks/getActives';

  static const String customerBanks = '/CustomerBanks';
  static const String customerBanksAddMerchant = '$customerBanks/addMerchant';
  static String deleteBank(String ibanNumber) => '$customerBanks/$ibanNumber';

  static const String customers = '/Customers';
  static const String logOut = '$customers/logout';

  static const String helps = '/Helps';

  static const String requestMoney = '/RequestMoneys';
  static String deleteRequestMoney(int id) => '$requestMoney/$id';
  static const String senderRequestMoneyList =
      '$requestMoney/senderRequestMoney';
  static const String buyerRequestMoneyList = '$requestMoney/buyerRequestMoney';

  static const String wallets = '/Wallets';
  static const String wallet = '$wallets/getActive';
  static const String merchantWallet = '$wallets/getMerchantWallet';

  static const String payCoreCustomers = '/PayCoreCustomers';
  static const String createPayCoreCustomer =
      '$payCoreCustomers/create-customer';
  static const String createPayCorePrepaidCard =
      '$payCoreCustomers/create-prepaid-card';
  static const String updatePayCoreCustomerAddress =
      '$payCoreCustomers/update-customer-address';
  static String getPayCoreCustomerInfo(String customerNumber) =>
      '$payCoreCustomers/get-customer-info/$customerNumber';

  static const String payCoreCards = '/PayCoreCards';
  static const String getMyPayCoreCards = '$payCoreCards/my-cards';
  static String getPayCoreCardTransactions(int cardId) =>
      '$payCoreCards/transactions/$cardId';
  static const String getMyPayCoreCustomerInfo = '$payCoreCards/customer-info';
  static String getPayCorePinStatus(int cardId) =>
      '$payCoreCards/get-last-pin-set-date/$cardId';
  static const String setPayCorePin = '$payCoreCards/set-pin';
  static const String setPayCoreRandomPin = '$payCoreCards/set-random-pin';
  static const String sendPayCorePinBySms = '$payCoreCards/send-pin-by-sms';
  static const String cancelPayCoreCard = '$payCoreCards/cancel-card';
  static const String setPayCorePrimaryCard = '$payCoreCards/set-primary-card';
  static String getPayCoreCardAuthorization(int cardId) =>
      '$payCoreCards/card-authorization/$cardId';
  static String getPayCoreVirtualCardSecurity(int cardId) =>
      '$payCoreCards/card-security/$cardId';
  static const String updatePayCoreCardEcommerceAuthorization =
      '$payCoreCards/card-ecommerce-authorization';
  static const String addPayCorePhysicalCard =
      '$payCoreCards/add-physical-card';
  static const String sendAddPayCorePhysicalCardOtp =
      '$payCoreCards/add-physical-card/send-otp';
  static const String confirmAddPayCorePhysicalCardOtp =
      '$payCoreCards/add-physical-card/confirm-otp';
  static const String getPayCoreAtmQrInfo = '$payCoreCards/atm-qr/info';
  static const String startPayCoreAtmQr = '$payCoreCards/atm-qr/start';

  static const String transfers = '/Transfers';
  static const String walletTransfer = '$transfers/walletTransfer';
  static const String merchantTransfer = '$transfers/merchantTransfer';
  static String walletTransferComplete(String transactionId) =>
      '$transfers/walletTransferComplete/$transactionId';
  static const String withdrawTransfer = '$transfers/withdrawTransfer';
  static String withdrawTransferComplete(String transactionId) =>
      '$transfers/withdrawTransferComplete/$transactionId';
  static const String withDrawMerchantTransfer =
      '$transfers/withDrawMerchantTransfer';
  static String merchantWithDrawTransferComplete(String transactionId) =>
      '$transfers/merchantWithDrawTransferComplete/$transactionId';

  static const String transactions = '/Transactions';
  static String getLastTransactions(int dataSize) =>
      '$transactions/getLastTransactions/$dataSize';
  static String getMerchantLastTransactions(int dataSize) =>
      '$transactions/getMerchantLastTransactions/$dataSize';
  static const String getTransactions = '$transactions/getTransactions';
  static const String getMerchantUserTransactions =
      '$transactions/getMerchantUserTransactions';
  static String getTransactionReceipt(String id) =>
      '$transactions/getTransactionReceipt/$id';
  static const String customerProcessList =
      '$transactions/getCustomerProcessList';
  static const String getMerchantProcessList =
      '$transactions/getMerchantProcessList';

  static const String scoreOperations = '/ScoreOperations';
  static const String userScoreCalculate =
      '$scoreOperations/userScoreCalculate';
  static const String scoreOperationList =
      '$scoreOperations/getListScoreOperation';

  static const String userPhoneChanges = '/UserPhoneChanges';
  static const String changePhoneCode = '$userPhoneChanges/changePhoneCode';
  static const String changePhone = '$userPhoneChanges/changePhone';

  static const String contracts = '/Contracts';
  static String getContractByContractCode(String contractCode) =>
      '$contracts/getContractByContractCode/$contractCode';

  static const String constantsDataList = '/ConstantsDataList';
  static const String averageRevenueTypes =
      '$constantsDataList/getAverageRevenueTypes';
  static const String monthlyTransactionCountTypes =
      '$constantsDataList/getMonthlyTransactionCountTypes';

  static const String arkSigners = '/ArkSigners';
  static const String frontImageCheck = '$arkSigners/frontImageCheck';
  static const String backImageCheck = '$arkSigners/backImageCheck';
  static const String faceImageCheck = '$arkSigners/faceImageCheck';
  static const String nfcCheck = '$arkSigners/nfcCheck';

  static const String userQuestions = '/UserQuestions';

  static const String userAddressInformations = '/UserAddressInformations';
  static const String addressNumberInquiry =
      '$userAddressInformations/addressNumberInquiry';
  static const String getUserAddressInformation =
      '$userAddressInformations/getUserAddressInformation';
  static const String userAddressInformationApprove =
      '$userAddressInformations/userAddressInformationApprove';

  static const String wrongLoginAttempts = '/WrongLoginAttempts';
  static const String getCurrentCustomerWrongPasswordHistories =
      '$wrongLoginAttempts/getCurrentCustomerWrongPasswordHistories';

  static const String bills = '/Bills';
  static const String getProductTypes = '$bills/getProductTypes';
  static const String getCacheProductList = '$bills/getCacheProductTypeList';
  static String getProduct(String productTypeId) =>
      '$bills/getProduct/$productTypeId';
  static String productQueryDefinition(String productId) =>
      '$bills/productQueryDefinition/$productId';
  static const String getBillInquiry = '$bills/getBillInquiry';
  static const String billPayment = '$bills/billPayment';

  static const String iwallet = '/IWallet';
  static const String campaigns = '$iwallet/campaigns';

  static const String mobileAdmins = '/MobileAdmins';
  static const String userCount = '$mobileAdmins/userCount';
  static const String merchantCount = '$mobileAdmins/merchantCount';
  static const String commissionSummary = '$mobileAdmins/commissionSummary';
  static const String walletTransferSummary =
      '$mobileAdmins/walletTransferSummary';
  static const String depositTransferSummary =
      '$mobileAdmins/depositTransferSummary';
  static const String withDrawTransferSummary =
      '$mobileAdmins/withDrawTransferSummary';
  static const String createCard = '$iwallet/createCard';
  static const String createQrCode = '$iwallet/createQrCode';
  static const String iwalletAgreements = '$iwallet/agreements';

  static const String internationalMoneyTransfer =
      '/InternationalMoneyTransfer';
  static const String getCountryList =
      '$internationalMoneyTransfer/getCountryList';
  static String getCountryTransactionType(String countryCode) =>
      '$internationalMoneyTransfer/getCountryTransactionType/$countryCode';
  static const String getRequiredAttributes =
      '$internationalMoneyTransfer/getRequiredAttributes';
  static const String cashPayoutSendTransfer =
      '$internationalMoneyTransfer/corpSendRequest';
  static String confirmInternationalTransfer(String transactionId) =>
      '$internationalMoneyTransfer/corpSendRequestConfirm/$transactionId';
  static const String getBicBankList =
      '$internationalMoneyTransfer/getBicBankList';
  static const String getOffices = '$internationalMoneyTransfer/getOffices';
  static String getCardBinCode(String countryCode) =>
      '$internationalMoneyTransfer/getCardBinCode/$countryCode';
  static String getWalletOperator(String countryCode) =>
      '$internationalMoneyTransfer/getWalletOperator/$countryCode';
  static String getTransferInfo(String referenceNumber) =>
      '$internationalMoneyTransfer/getTransferInfo/$referenceNumber';

  static const String customerDemands = '/CustomerDemands';
  static const String customerDemandSubjectTypes =
      '$customerDemands/getCustomerDemandRequsetSubjectTypes';
  static const String createCustomerDemand =
      '$customerDemands/createCustomerDemand';

  static const String avatarImages = '/AvatarImages';

  static const String customerAvatars = '/CustomerAvatars';
  static String selectCustomerAvatar(int avatarId) =>
      '$customerAvatars/$avatarId';
  static const String deleteCustomerAvatar = customerAvatars;

  static const String frequentIbans = '/FrequentIbans';
  static String deleteFrequentIban(String id) => '$frequentIbans/$id';

  static const String frequentlySents = '/FrequentlySents';
  static const String getListFrequentlySent =
      '$frequentlySents/getListFrequentlySent';
  static String addFrequentlySent(String customerNumber) =>
      '$frequentlySents/addFrequentlySent/$customerNumber';
  static String deleteFrequentlySent(int id) =>
      '$frequentlySents/deleteFrequentlySent/$id';

  static const String giftChecks = '/GiftChecks';
  static const String getGiftCheckCategories = '$giftChecks/getCategories';
  static String getGiftCheckBrands(String categoryId) =>
      '$giftChecks/getBrands/$categoryId';
  static String getGiftCheckBrandDetail(String brandId) =>
      '$giftChecks/getBrandDetail/$brandId';
  static String getGiftCheckCoupons(String brandId) =>
      '$giftChecks/getCoupons/$brandId';
  static const String couponsTake = '$giftChecks/couponsTake';
  static const String getCustomerCoupons = '$giftChecks/getCustomerCoupons';

  static const String metropols = '/Metropols';
  static const String getCities = '$metropols/getCities';
  static const String pointOfSaleLocationList =
      '$metropols/pointOfSaleLocationList';
  static const String pointOfSaleLocationFilterList =
      '$metropols/pointOfSaleLocationFilterList';
  static const String createUserOrDetail = '$metropols/createUserOrDetail';
  static const String getUserBalance = '$metropols/getUserBalance';
  static const String getMetropolTransactionList =
      '$metropols/getTransactionList';
  static const String metropolTransfer = '$transfers/metropolTransfer';
  static const String metropolTransferComplete =
      '$transfers/metropolTransferComplete';
  static const String metropolGiftTransfer = '$transfers/metropolGiftTransfer';
  static const String metropolDrawBackTransfer =
      '$transfers/metropolDrawBackTransfer';

  static const String fuelCards = '/FuelCards';
  static const String createFuelCard = '$fuelCards/create';
  static const String getFuelCards = '$fuelCards/getCards';
  static String deleteFuelCard(int id) => '$fuelCards/delete/$id';
  static const String fuelCardTopUp = '$fuelCards/topup';
  static String getFuelCardBalance(int id) => '$fuelCards/getBalance/$id';
}
