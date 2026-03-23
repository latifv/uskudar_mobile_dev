part of 'customer_coupons_bloc.dart';

sealed class CustomerCouponsEvent {
  const CustomerCouponsEvent();
}

final class CustomerCouponsLoad extends CustomerCouponsEvent {
  const CustomerCouponsLoad();
}
