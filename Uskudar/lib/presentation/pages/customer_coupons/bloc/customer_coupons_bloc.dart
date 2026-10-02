import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/customer_coupon.dart';
import 'package:payinall/domain/usecases/get_customer_coupons_usecase.dart';

part 'customer_coupons_event.dart';
part 'customer_coupons_state.dart';

final class CustomerCouponsBloc
    extends Bloc<CustomerCouponsEvent, CustomerCouponsState> {
  CustomerCouponsBloc({required this.getCustomerCouponsUsecase})
    : super(const CustomerCouponsState()) {
    on<CustomerCouponsLoad>(_loadCoupons);
  }

  final GetCustomerCouponsUsecase getCustomerCouponsUsecase;

  Future<void> _loadCoupons(
    CustomerCouponsLoad event,
    Emitter<CustomerCouponsState> emit,
  ) async {
    emit(state.copyWith(status: CustomerCouponsStatus.loading));

    final result = await getCustomerCouponsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CustomerCouponsStatus.error,
          message: failure.message,
        ),
      ),
      (coupons) => emit(
        state.copyWith(
          status: CustomerCouponsStatus.loaded,
          coupons: coupons,
        ),
      ),
    );
  }
}
