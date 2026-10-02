// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:uskudar_mobile/core/constants/app_constants.dart';
// import 'package:uskudar_mobile/di/di.dart';
// import 'package:uskudar_mobile/presentation/pages/address_confirmation/bloc/address_confirmation_bloc.dart';
// import 'package:uskudar_mobile/presentation/route/app_router.dart';
// import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/launch_url_extension.dart';

// mixin AddressConfirmationMixin<T extends StatefulWidget> on State<T> {
//   late final AddressConfirmationBloc bloc;
//   late final TextEditingController addressTextController;
//   late final GlobalKey<FormState> addressFormKey;

//   @override
//   void initState() {
//     addressTextController = TextEditingController();
//     addressFormKey = GlobalKey<FormState>();
//     bloc = getIt<AddressConfirmationBloc>();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     addressTextController.dispose();
//     addressFormKey.currentState?.dispose();
//     bloc.close();
//     super.dispose();
//   }

//   void blocListener(BuildContext context, AddressConfirmationState state) {
//     if (state.status == AddressConfirmationStatus.error &&
//         state.message != null) {
//       ToastComponent.showErrorToast(context: context, message: state.message);
//     } else if (state.status == AddressConfirmationStatus.success) {
//       context.router.replace(const FrontIdScanRoute());
//     }
//   }

//   Future<void> onSubmit() async {
//     FocusScope.of(context).unfocus();
//     if (addressFormKey.currentState?.validate() != true) {
//       return;
//     }

//     bloc.add(
//       AddressConfirmationSubmit(
//         addressNumber: addressTextController.text.trim(),
//       ),
//     );
//   }

//   Future<void> openNviAddressUrl() async {
//     await AppConstants.nviAddressUrl.launchAsUrl();
//   }
// }
