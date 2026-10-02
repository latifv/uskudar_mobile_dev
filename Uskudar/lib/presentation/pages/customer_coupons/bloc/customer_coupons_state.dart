part of 'customer_coupons_bloc.dart';

enum CustomerCouponsStatus { initial, loading, loaded, error }

final class CustomerCouponsState extends Equatable {
  const CustomerCouponsState({
    this.status = CustomerCouponsStatus.initial,
    this.coupons,
    this.message,
  });

  final CustomerCouponsStatus status;
  final List<CustomerCoupon>? coupons;
  final String? message;

  CustomerCouponsState copyWith({
    CustomerCouponsStatus? status,
    List<CustomerCoupon>? coupons,
    String? message,
  }) {
    return CustomerCouponsState(
      status: status ?? this.status,
      coupons: coupons ?? this.coupons,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, coupons, message];
}
