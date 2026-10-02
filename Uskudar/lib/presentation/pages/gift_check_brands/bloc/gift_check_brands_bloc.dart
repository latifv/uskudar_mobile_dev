import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand.dart';
import 'package:uskudar_mobile/domain/usecases/get_gift_check_brands_usecase.dart';

part 'gift_check_brands_event.dart';
part 'gift_check_brands_state.dart';

final class GiftCheckBrandsBloc
    extends Bloc<GiftCheckBrandsEvent, GiftCheckBrandsState> {
  GiftCheckBrandsBloc({required this.getGiftCheckBrandsUsecase})
    : super(const GiftCheckBrandsState()) {
    on<GiftCheckBrandsLoad>(_loadBrands);
  }

  final GetGiftCheckBrandsUsecase getGiftCheckBrandsUsecase;

  Future<void> _loadBrands(
    GiftCheckBrandsLoad event,
    Emitter<GiftCheckBrandsState> emit,
  ) async {
    emit(state.copyWith(status: GiftCheckBrandsStatus.loading));

    final result = await getGiftCheckBrandsUsecase(event.categoryId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GiftCheckBrandsStatus.error,
          message: failure.message,
        ),
      ),
      (brands) => emit(
        state.copyWith(
          status: GiftCheckBrandsStatus.loaded,
          brands: brands,
        ),
      ),
    );
  }
}
