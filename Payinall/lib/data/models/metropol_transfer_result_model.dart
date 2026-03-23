import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/metropol_transfer_result_response.dart';
import 'package:payinall/domain/entities/metropol_transfer_result.dart';

final class MetropolTransferResultModel extends MetropolTransferResult {
  const MetropolTransferResultModel({
    required super.merchantName,
    required super.cityName,
    required super.districtName,
    required super.requestAmount,
    required super.transactionId,
    required super.productName,
    required super.kdv,
    required super.saleRefCode,
    required super.sessionExpireDate,
  });

  factory MetropolTransferResultModel.fromResponse(
    MetropolTransferResultResponse response,
  ) {
    if (response.transactionId == null) {
      throw const MappingException();
    }

    return MetropolTransferResultModel(
      merchantName: response.merchantName ?? '',
      cityName: response.cityName ?? '',
      districtName: response.districtName ?? '',
      requestAmount: response.requestAmount ?? '',
      transactionId: response.transactionId!,
      productName: response.productName ?? '',
      kdv: response.kdv ?? '',
      saleRefCode: response.saleRefCode ?? '',
      sessionExpireDate: response.sessionExpireDate ?? '',
    );
  }
}
