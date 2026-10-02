// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:payinall/core/error/failures.dart';
// import 'package:payinall/domain/params/address_number_inquiry_params.dart';
// import 'package:payinall/domain/usecases/address_number_inquiry_usecase.dart';

// part 'address_confirmation_event.dart';
// part 'address_confirmation_state.dart';

// final class AddressConfirmationBloc
//     extends Bloc<AddressConfirmationEvent, AddressConfirmationState> {
//   AddressConfirmationBloc({required this.addressNumberInquiryUsecase})
//     : super(const AddressConfirmationState()) {
//     on<AddressConfirmationSubmit>(_onAddressConfirmationSubmit);
//   }

//   final AddressNumberInquiryUsecase addressNumberInquiryUsecase;

//   Future<void> _onAddressConfirmationSubmit(
//     AddressConfirmationSubmit event,
//     Emitter<AddressConfirmationState> emit,
//   ) async {
//     if (state.status == AddressConfirmationStatus.processing) {
//       return;
//     }

//     emit(state.copyWith(status: AddressConfirmationStatus.processing));

//     final params = AddressNumberInquiryParams(
//       addressNumber: event.addressNumber,
//     );
//     final result = await addressNumberInquiryUsecase(params);

//     result.fold(
//       (failure) => emit(
//         state.copyWith(
//           status: AddressConfirmationStatus.error,
//           message: failure.message,
//         ),
//       ),
//       (_) => emit(state.copyWith(status: AddressConfirmationStatus.success)),
//     );
//   }
// }
