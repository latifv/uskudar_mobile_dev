import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_coupon_response.dart';
import 'package:uskudar_mobile/domain/entities/customer_coupon.dart';

final class CustomerCouponModel extends CustomerCoupon {
  const CustomerCouponModel({
    required super.id,
    required super.fullName,
    required super.customerNumber,
    required super.customerId,
    required super.code,
    required super.pin,
    required super.merchantName,
    required super.logo,
    required super.purchaseDate,
    required super.amount,
    required super.cashbackAmount,
    required super.isDeleted,
  });

  factory CustomerCouponModel.fromResponse(CustomerCouponResponse response) {
    if (response.id == null ||
        response.fullName == null ||
        response.customerNumber == null ||
        response.customerId == null ||
        response.code == null ||
        response.pin == null ||
        response.merchantName == null ||
        response.logo == null ||
        response.purchaseDate == null ||
        response.amount == null ||
        response.cashbackAmount == null ||
        response.isDeleted == null) {
      throw const MappingException();
    }

    return CustomerCouponModel(
      id: response.id!,
      fullName: response.fullName!,
      customerNumber: response.customerNumber!,
      customerId: response.customerId!,
      code: response.code!,
      pin: response.pin!,
      merchantName: response.merchantName!,
      logo: response.logo!,
      purchaseDate: DateTime.parse(response.purchaseDate!),
      amount: response.amount!,
      cashbackAmount: response.cashbackAmount!,
      isDeleted: response.isDeleted!,
    );
  }
}
