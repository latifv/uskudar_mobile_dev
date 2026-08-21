import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/fuel_card.dart';
import 'package:payinall/presentation/pages/fuel_cards/bloc/fuel_cards_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin FuelCardsMixin<T extends StatefulWidget> on State<T> {
  late final FuelCardsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<FuelCardsBloc>();
    loadCards();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadCards() {
    bloc.add(const FuelCardsLoad());
  }

  void navigateToTopUp(FuelCard card) {
    unawaited(
      context.router
          .push(FuelCardTopUpRoute(fuelCardId: card.id, cardNo: card.cardNo))
          .then((_) => loadCards()),
    );
  }

  void onDeleteCard(int cardId) {
    unawaited(
      showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(LocaleKeys.delete_card.translate),
          content: Text(LocaleKeys.delete_card_confirmation.translate),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(LocaleKeys.cancel.translate),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(LocaleKeys.delete.translate),
            ),
          ],
        ),
      ).then((confirmed) {
        if (confirmed == true) {
          bloc.add(FuelCardDeleteRequested(cardId: cardId));
        }
      }),
    );
  }

  void blocListener(BuildContext context, FuelCardsState state) {
    if (state.status == FuelCardsStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == FuelCardsStatus.deleted) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.successMessage ?? '',
      );
    }
  }
}
