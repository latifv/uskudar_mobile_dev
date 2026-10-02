import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
// import 'package:uskudar_mobile/domain/enums/agreement_type.dart';
import 'package:uskudar_mobile/presentation/pages/address_preview/bloc/address_preview_bloc.dart';
// import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

mixin AddressPreviewMixin<T extends StatefulWidget> on State<T> {
  late final AddressPreviewBloc bloc;
  late final TextEditingController addressController;

  @override
  void initState() {
    bloc = getIt<AddressPreviewBloc>();
    addressController = TextEditingController();
    bloc.add(const AddressPreviewStarted());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showAgreement();
    // });
    super.initState();
  }

  // Future<void> _showAgreement() async {
  //   final result = await context.router.push(
  //     AgreementRoute(
  //       agreementType: AgreementType.adresBilgisiSozlesmesi.getValue,
  //       isRead: false,
  //     ),
  //   );
  //   if (result != true) {
  //     if (mounted) {
  //       context.router.pop();
  //     }
  //   }
  // }

  @override
  void dispose() {
    addressController.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, AddressPreviewState state) {
    if (state.status == AddressPreviewStatus.error && state.message != null) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    } else if (state.status == AddressPreviewStatus.approved) {
      ToastComponent.showSuccessToast(
        context: context,
        message: LocaleKeys.address_preview_success.translate,
      );
      context.router.pop();
    }
  }

  void onApprovePressed() {
    final addressInfo = bloc.state.userAddressInformation;
    if (addressInfo != null) {
      bloc.add(const AddressPreviewApproved(isManuel: false));
    }
  }

  void onDifferentAddressPressed() {
    unawaited(_showManualAddressDialog());
  }

  Future<void> _showManualAddressDialog() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(LocaleKeys.different_address.translate),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                LocaleKeys.please_enter_correct_address.translate,
                style: context.textTheme.bodyMedium,
              ),
              context.spacingNormalHeight,
              TextFormField(
                controller: addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: LocaleKeys.address.translate,
                  hintText: LocaleKeys.address_hint.translate,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.router.pop(),
              child: Text(LocaleKeys.cancel.translate),
            ),
            ElevatedButton(
              onPressed: () {
                final address = addressController.text.trim();
                if (address.isNotEmpty) {
                  dialogContext.router.pop(address);
                } else {
                  ToastComponent.showErrorToast(
                    context: dialogContext,
                    message: LocaleKeys.please_enter_address.translate,
                  );
                }
              },
              child: Text(LocaleKeys.approve.translate),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      bloc.add(AddressPreviewApproved(isManuel: true, address: result));
    }
  }

  void onRetryPressed() {
    bloc.add(const AddressPreviewStarted());
  }
}
