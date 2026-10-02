import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/help.dart';
import 'package:uskudar_mobile/domain/usecases/get_helps_usecase.dart';

part 'faq_event.dart';
part 'faq_state.dart';

final class FaqBloc extends Bloc<FaqEvent, FaqState> {
  FaqBloc({required this.getHelpsUsecase}) : super(const FaqState()) {
    on<FaqLoadData>(_loadData);
    on<FaqToggleExpanded>(_toggleExpanded);
  }

  final GetHelpsUsecase getHelpsUsecase;

  Future<void> _loadData(FaqLoadData event, Emitter<FaqState> emit) async {
    emit(state.copyWith(status: FaqStatus.loading));

    final result = await getHelpsUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: FaqStatus.error, message: failure.message),
      ),
      (helps) => emit(state.copyWith(status: FaqStatus.loaded, helps: helps)),
    );
  }

  void _toggleExpanded(FaqToggleExpanded event, Emitter<FaqState> emit) {
    if (state.status == FaqStatus.loaded) {
      final currentState = state;
      final expandStates = Map<int, bool>.from(currentState.expandStates);

      expandStates[event.index] = !(expandStates[event.index] ?? false);

      emit(currentState.copyWith(expandStates: expandStates));
    }
  }
}
