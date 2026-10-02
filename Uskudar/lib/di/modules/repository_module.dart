import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/data/repositories/admin_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/app_banks_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/app_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/ark_signers_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/auth_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/avatar_images_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/bills_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/campaigns_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/commissions_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/constants_data_list_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/contracts_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customer_activations_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customer_banks_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customer_demands_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customer_mobiles_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customer_register_code_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/customers_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/frequent_ibans_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/frequently_sents_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/fuel_cards_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/gift_checks_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/helps_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/metropols_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/international_money_transfer_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/login_attempts_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/notification_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/passwords_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/request_moneys_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/score_operations_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/transactions_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/transfers_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/user_address_informations_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/user_phone_changes_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/user_questions_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/users_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/wallets_repository_impl.dart';
import 'package:uskudar_mobile/data/repositories/wrong_login_attempts_repository_impl.dart';
import 'package:uskudar_mobile/di/di_module.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';
import 'package:uskudar_mobile/domain/repositories/app_banks_repository.dart';
import 'package:uskudar_mobile/domain/repositories/app_repository.dart';
import 'package:uskudar_mobile/domain/repositories/ark_signers_repository.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';
import 'package:uskudar_mobile/domain/repositories/avatar_images_repository.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';
import 'package:uskudar_mobile/domain/repositories/campaigns_repository.dart';
import 'package:uskudar_mobile/domain/repositories/commissions_repository.dart';
import 'package:uskudar_mobile/domain/repositories/constants_data_list_repository.dart';
import 'package:uskudar_mobile/domain/repositories/contracts_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customer_activations_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customer_banks_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customer_demands_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customer_mobiles_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customer_register_code_repository.dart';
import 'package:uskudar_mobile/domain/repositories/customers_repository.dart';
import 'package:uskudar_mobile/domain/repositories/frequent_ibans_repository.dart';
import 'package:uskudar_mobile/domain/repositories/frequently_sents_repository.dart';
import 'package:uskudar_mobile/domain/repositories/fuel_cards_repository.dart';
import 'package:uskudar_mobile/domain/repositories/gift_checks_repository.dart';
import 'package:uskudar_mobile/domain/repositories/helps_repository.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';
import 'package:uskudar_mobile/domain/repositories/international_money_transfer_repository.dart';
import 'package:uskudar_mobile/domain/repositories/login_attempts_repository.dart';
import 'package:uskudar_mobile/domain/repositories/notification_repository.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';
import 'package:uskudar_mobile/domain/repositories/request_moneys_repository.dart';
import 'package:uskudar_mobile/domain/repositories/score_operations_repository.dart';
import 'package:uskudar_mobile/domain/repositories/transactions_repository.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';
import 'package:uskudar_mobile/domain/repositories/user_address_informations_repository.dart';
import 'package:uskudar_mobile/domain/repositories/user_phone_changes_repository.dart';
import 'package:uskudar_mobile/domain/repositories/user_questions_repository.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';
import 'package:uskudar_mobile/domain/repositories/wallets_repository.dart';
import 'package:uskudar_mobile/domain/repositories/wrong_login_attempts_repository.dart';

final class RepositoryModule extends DIModule {
  @override
  Future<void> setup(GetIt getIt) async {
    getIt
      ..registerSingleton<AppRepository>(
        AppRepositoryImpl(localDataSource: getIt()),
      )
      ..registerSingleton<AuthRepository>(
        AuthRepositoryImpl(
          localDataSource: getIt(),
          remoteDataSource: getIt(),
          tokenManager: getIt(),
        ),
      )
      ..registerSingleton<ContractsRepository>(
        ContractsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<AppBanksRepository>(
        () => AppBanksRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<BillsRepository>(
        () => BillsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CampaignsRepository>(
        () => CampaignsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CommissionsRepository>(
        () => CommissionsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CustomerActivationsRepository>(
        () => CustomerActivationsRepositoryImpl(
          remoteDataSource: getIt(),
          tokenManager: getIt(),
        ),
      )
      ..registerLazySingleton<CustomerBanksRepository>(
        () => CustomerBanksRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CustomerMobilesRepository>(
        () => CustomerMobilesRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CustomerRegisterCodeRepository>(
        () => CustomerRegisterCodeRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CustomersRepository>(
        () => CustomersRepositoryImpl(
          localDataSource: getIt(),
          remoteDataSource: getIt(),
        ),
      )
      ..registerLazySingleton<HelpsRepository>(
        () => HelpsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<InternationalMoneyTransferRepository>(
        () =>
            InternationalMoneyTransferRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<LoginAttemptsRepository>(
        () => LoginAttemptsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<PasswordsRepository>(
        () => PasswordsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<RequestMoneysRepository>(
        () => RequestMoneysRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<ScoreOperationsRepository>(
        () => ScoreOperationsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<TransactionsRepository>(
        () => TransactionsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<TransfersRepository>(
        () => TransfersRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<UserPhoneChangesRepository>(
        () => UserPhoneChangesRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<UsersRepository>(
        () => UsersRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<WalletsRepository>(
        () => WalletsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<ConstantsDataListRepository>(
        () => ConstantsDataListRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<ArkSignersRepository>(
        () => ArkSignersRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<UserQuestionsRepository>(
        () => UserQuestionsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<UserAddressInformationsRepository>(
        () => UserAddressInformationsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<WrongLoginAttemptsRepository>(
        () => WrongLoginAttemptsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<AdminRepository>(
        () => AdminRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerSingleton<NotificationRepository>(
        NotificationRepositoryImpl(localDataSource: getIt()),
      )
      ..registerLazySingleton<AvatarImagesRepository>(
        () => AvatarImagesRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<CustomerDemandsRepository>(
        () => CustomerDemandsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<FrequentIbansRepository>(
        () => FrequentIbansRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<FrequentlySentsRepository>(
        () => FrequentlySentsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<GiftChecksRepository>(
        () => GiftChecksRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<MetropolsRepository>(
        () => MetropolsRepositoryImpl(remoteDataSource: getIt()),
      )
      ..registerLazySingleton<FuelCardsRepository>(
        () => FuelCardsRepositoryImpl(remoteDataSource: getIt()),
      );
  }
}
