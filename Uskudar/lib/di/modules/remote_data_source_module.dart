import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/data/datasources/remote/admin_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/app_banks_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/ark_signers_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/auth_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/avatar_images_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/bills_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/campaigns_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/commissions_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/constants_data_list_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/contract_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_activations_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_banks_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_demands_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_mobiles_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customer_register_code_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/customers_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/frequent_ibans_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/frequently_sents_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/fuel_cards_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/gift_checks_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/helps_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/metropols_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/international_money_transfer_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/login_attempts_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/passwords_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/requst_moneys_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/score_operations_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/transactions_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/transfers_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/user_address_informations_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/user_phone_changes_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/user_questions_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/users_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/wallets_remote_data_source.dart';
import 'package:uskudar_mobile/data/datasources/remote/wrong_login_attempts_remote_data_source.dart';
import 'package:uskudar_mobile/di/di_module.dart';

final class RemoteDataSourceModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImpl(getIt()),
      )
      ..registerSingleton<ContractsRemoteDataSource>(
        ContractsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<AppBanksRemoteDataSource>(
        () => AppBanksRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<BillsRemoteDataSource>(
        () => BillsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CampaignsRemoteDataSource>(
        () => CampaignsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CommissionsRemoteDataSource>(
        () => CommissionsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomerActivationsRemoteDataSource>(
        () => CustomerActivationsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomerBanksRemoteDataSource>(
        () => CustomerBanksRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomerMobilesRemoteDataSource>(
        () => CustomerMobilesRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomerRegisterCodeRemoteDataSource>(
        () => CustomerRegisterCodeRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomersRemoteDataSource>(
        () => CustomersRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<HelpsRemoteDataSource>(
        () => HelpsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<LoginAttemptsRemoteDataSource>(
        () => LoginAttemptsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<PasswordsRemoteDataSource>(
        () => PasswordsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<RequestMoneysRemoteDataSource>(
        () => RequestMoneysRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<ScoreOperationsRemoteDataSource>(
        () => ScoreOperationsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<TransactionsRemoteDataSource>(
        () => TransactionsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<TransfersRemoteDataSource>(
        () => TransfersRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<UserPhoneChangesRemoteDataSource>(
        () => UserPhoneChangesRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<UsersRemoteDataSource>(
        () => UsersRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<WalletsRemoteDataSource>(
        () => WalletsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<ConstantsDataListRemoteDataSource>(
        () => ConstantsDataListRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<ArkSignersRemoteDataSource>(
        () => ArkSignersRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<UserQuestionsRemoteDataSource>(
        () => UserQuestionsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<UserAddressInformationsRemoteDataSource>(
        () => UserAddressInformationsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<WrongLoginAttemptsRemoteDataSource>(
        () => WrongLoginAttemptsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<AdminRemoteDataSource>(
        () => AdminRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<InternationalMoneyTransferRemoteDataSource>(
        () => InternationalMoneyTransferRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<AvatarImagesRemoteDataSource>(
        () => AvatarImagesRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<CustomerDemandsRemoteDataSource>(
        () => CustomerDemandsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<FrequentIbansRemoteDataSource>(
        () => FrequentIbansRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<FrequentlySentsRemoteDataSource>(
        () => FrequentlySentsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<GiftChecksRemoteDataSource>(
        () => GiftChecksRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<MetropolsRemoteDataSource>(
        () => MetropolsRemoteDataSourceImpl(getIt()),
      )
      ..registerLazySingleton<FuelCardsRemoteDataSource>(
        () => FuelCardsRemoteDataSourceImpl(getIt()),
      );
  }
}
