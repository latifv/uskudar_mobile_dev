import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/usecases/get_gift_check_categories_usecase.dart';

part 'gift_checks_event.dart';
part 'gift_checks_state.dart';

final class GiftChecksBloc extends Bloc<GiftChecksEvent, GiftChecksState> {
  GiftChecksBloc({required this.getGiftCheckCategoriesUsecase})
    : super(const GiftChecksState()) {
    on<GiftChecksLoadCategories>(_loadCategories);
  }

  final GetGiftCheckCategoriesUsecase getGiftCheckCategoriesUsecase;

  Future<void> _loadCategories(
    GiftChecksLoadCategories event,
    Emitter<GiftChecksState> emit,
  ) async {
    emit(state.copyWith(status: GiftChecksStatus.loading));

    final result = await getGiftCheckCategoriesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GiftChecksStatus.error,
          message: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          status: GiftChecksStatus.loaded,
          categories: categories,
        ),
      ),
    );
  }
}
