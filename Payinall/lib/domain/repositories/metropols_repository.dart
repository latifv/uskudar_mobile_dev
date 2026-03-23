import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/entities/metropol_transaction.dart';
import 'package:payinall/domain/entities/metropol_transfer_result.dart';
import 'package:payinall/domain/entities/metropol_user_balance.dart';
import 'package:payinall/domain/entities/metropol_user_detail.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/domain/params/metropol_draw_back_transfer_params.dart';
import 'package:payinall/domain/params/metropol_gift_transfer_params.dart';
import 'package:payinall/domain/params/metropol_transaction_list_params.dart';
import 'package:payinall/domain/params/metropol_transfer_complete_params.dart';
import 'package:payinall/domain/params/metropol_transfer_params.dart';
import 'package:payinall/domain/params/point_of_sale_location_filter_params.dart';
import 'package:payinall/domain/params/point_of_sale_location_params.dart';

abstract interface class MetropolsRepository {
  Future<Either<Failure, List<MetropolCity>>> getCities();
  Future<Either<Failure, List<PointOfSaleLocation>>> pointOfSaleLocationList(
    PointOfSaleLocationParams params,
  );
  Future<Either<Failure, List<PointOfSaleLocation>>>
      pointOfSaleLocationFilterList(
    PointOfSaleLocationFilterParams params,
  );
  Future<Either<Failure, MetropolUserDetail>> createUserOrDetail();
  Future<Either<Failure, MetropolUserBalance>> getUserBalance();
  Future<Either<Failure, List<MetropolTransaction>>> getTransactionList(
    MetropolTransactionListParams params,
  );
  Future<Either<Failure, MetropolTransferResult>> metropolTransfer(
    MetropolTransferParams params,
  );
  Future<Either<Failure, String>> metropolTransferComplete(
    MetropolTransferCompleteParams params,
  );
  Future<Either<Failure, String>> metropolGiftTransfer(
    MetropolGiftTransferParams params,
  );
  Future<Either<Failure, String>> metropolDrawBackTransfer(
    MetropolDrawBackTransferParams params,
  );
}
