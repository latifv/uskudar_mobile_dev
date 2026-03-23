import 'package:payinall/data/dtos/responses/bic_bank_response.dart';
import 'package:payinall/domain/entities/bic_bank.dart';

final class BicBankModel extends BicBank {
  const BicBankModel({
    required super.branchCode,
    required super.branchName,
    required super.code,
    required super.name,
  });

  factory BicBankModel.fromResponse(BicBankResponse response) => BicBankModel(
    branchCode: response.branchCode ?? '',
    branchName: response.branchName ?? '',
    code: response.code ?? '',
    name: response.name ?? '',
  );

  BicBank toEntity() => BicBank(
    branchCode: branchCode,
    branchName: branchName,
    code: code,
    name: name,
  );
}
