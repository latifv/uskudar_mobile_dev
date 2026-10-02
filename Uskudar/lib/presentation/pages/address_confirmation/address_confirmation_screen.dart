// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
// import 'package:uskudar_mobile/domain/validators/app_validators.dart';
// import 'package:uskudar_mobile/presentation/pages/address_confirmation/bloc/address_confirmation_bloc.dart';
// import 'package:uskudar_mobile/presentation/pages/address_confirmation/mixin/address_confirmation_mixin.dart';
// import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
// import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
// import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
// import 'package:uskudar_mobile/presentation/widgets/custom_processing.dart';
// import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
// import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

// @RoutePage()
// final class AddressConfirmationScreen extends StatefulWidget {
//   const AddressConfirmationScreen({super.key});

//   @override
//   State<AddressConfirmationScreen> createState() =>
//       _AddressConfirmationScreenState();
// }

// final class _AddressConfirmationScreenState
//     extends State<AddressConfirmationScreen>
//     with AddressConfirmationMixin {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => bloc,
//       child: BlocConsumer<AddressConfirmationBloc, AddressConfirmationState>(
//         listener: blocListener,
//         builder: (_, state) {
//           return Stack(
//             children: [
//               Scaffold(
//                 appBar: CustomAppBar(
//                   title: Text(LocaleKeys.address_confirmation_title.translate),
//                 ),
//                 body: SafeArea(
//                   child: Padding(
//                     padding: context.paddingBase,
//                     child: _buildBody(),
//                   ),
//                 ),
//               ),
//               if (state.status == AddressConfirmationStatus.processing)
//                 const CustomProcessing(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildInfoText(),
//         context.spacingMediumHeight,
//         _buildNviAddressButton(),
//         context.spacingMediumHeight,
//         _buildForm(),
//         const Spacer(),
//         _buildSubmitButton(),
//       ],
//     );
//   }

//   Widget _buildForm() {
//     return Form(key: addressFormKey, child: _buildAddressNumberField());
//   }

//   Widget _buildInfoText() {
//     return Text(
//       LocaleKeys.address_confirmation_description.translate,
//       style: context.textTheme.bodyMedium,
//     );
//   }

//   Widget _buildNviAddressButton() {
//     return InkWell(
//       onTap: openNviAddressUrl,
//       child: Container(
//         width: double.infinity,
//         padding: context.paddingLowAll,
//         decoration: BoxDecoration(
//           color: context.colorScheme.primary,
//           borderRadius: context.borderRadiusLowAll,
//         ),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 LocaleKeys.address_confirmation_address_title.translate,
//                 style: context.textTheme.bodyMedium?.copyWith(
//                   color: context.colorScheme.onSurface,
//                 ),
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios,
//               color: context.colorScheme.onSurface,
//               size: IconSizeConstants.n,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressNumberField() {
//     return CustomTextFormField(
//       controller: addressTextController,
//       hintText: LocaleKeys.address_confirmation_address_number_title.translate,
//       keyboardType: TextInputType.number,
//       validator: AppValidators.required,
//     );
//   }

//   Widget _buildSubmitButton() {
//     return PrimaryElevatedButton(
//       onPressed: onSubmit,
//       text: LocaleKeys.verify.translate,
//     );
//   }
// }
