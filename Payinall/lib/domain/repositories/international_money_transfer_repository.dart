import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/bic_bank.dart';
import 'package:payinall/domain/entities/card_bin.dart';
import 'package:payinall/domain/entities/corporation_attribute.dart';
import 'package:payinall/domain/entities/country.dart';
import 'package:payinall/domain/entities/country_transaction_type.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';
import 'package:payinall/domain/entities/office.dart';
import 'package:payinall/domain/entities/wallet_operator.dart';
import 'package:payinall/domain/params/cash_payout_send_transfer_params.dart';
import 'package:payinall/domain/params/get_bic_bank_list_params.dart';
import 'package:payinall/domain/params/get_offices_params.dart';
import 'package:payinall/domain/params/get_required_attributes_params.dart';

abstract interface class InternationalMoneyTransferRepository {
  Future<Either<Failure, List<Country>>> getCountryList();

  Future<Either<Failure, CountryTransactionType>> getCountryTransactionType(
    String countryCode,
  );

  Future<Either<Failure, List<CorporationAttribute>>> getRequiredAttributes(
    GetRequiredAttributesParams params,
  );

  Future<Either<Failure, InternationalTransferResult>> cashPayoutSendTransfer(
    CashPayoutSendTransferParams params,
  );

  Future<Either<Failure, String>> confirmTransfer(String transactionId);

  Future<Either<Failure, List<BicBank>>> getBicBankList(
    GetBicBankListParams params,
  );

  Future<Either<Failure, List<Office>>> getOffices(
    GetOfficesParams params,
  );

  Future<Either<Failure, List<CardBin>>> getCardBinCode(String countryCode);

  Future<Either<Failure, List<WalletOperator>>> getWalletOperator(
    String countryCode,
  );

  Future<Either<Failure, String>> getTransferInfo(String referenceNumber);
}
