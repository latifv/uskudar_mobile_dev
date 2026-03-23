import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/enums/agreement_type.dart';
import 'package:payinall/presentation/route/app_router.dart';

final class AgreementListItem {
  const AgreementListItem({
    required this.type,
    required this.titleKey,
    required this.icon,
  });

  final AgreementType type;
  final String titleKey;
  final IconData icon;
}

const List<AgreementListItem> agreementListItems = [
  AgreementListItem(
    type: AgreementType.hakemHeyeti,
    titleKey: LocaleKeys.hakem_heyeti,
    icon: Icons.gavel_outlined,
  ),
  AgreementListItem(
    type: AgreementType.guvenlikSozlesmesi,
    titleKey: LocaleKeys.guvenlik_sozlesmesi,
    icon: Icons.security_outlined,
  ),
  AgreementListItem(
    type: AgreementType.bilgilendirmeMetni,
    titleKey: LocaleKeys.bilgilendirme_metni,
    icon: Icons.info_outline,
  ),
  AgreementListItem(
    type: AgreementType.adresBilgisiSozlesmesi,
    titleKey: LocaleKeys.adres_bilgisi_sozlesmesi,
    icon: Icons.home_work_outlined,
  ),
  AgreementListItem(
    type: AgreementType.kullaniciCerceveSozlesmesi,
    titleKey: LocaleKeys.kullanici_cerceve_sozlesmesi,
    icon: Icons.assignment_outlined,
  ),
  AgreementListItem(
    type: AgreementType.musteriEdinimiUzaktanKimlikTespitiAydinlatmaMetni,
    titleKey:
        LocaleKeys.musteri_edinimi_uzaktan_kimlik_tespiti_aydinlatma_metni,
    icon: Icons.how_to_reg_outlined,
  ),
  AgreementListItem(
    type: AgreementType.odemeHizmetiKullanicilariAydinlatmaMetni,
    titleKey: LocaleKeys.odeme_hizmeti_kullanicilari_aydinlatma_metni,
    icon: Icons.payments_outlined,
  ),
  AgreementListItem(
    type: AgreementType.biyometrikVeriRizasi,
    titleKey: LocaleKeys.biyometrik_veri_rizasi,
    icon: Icons.face_retouching_natural_outlined,
  ),
];

mixin AgreementsMixin<T extends StatefulWidget> on State<T> {
  List<AgreementListItem> get agreements => agreementListItems;

  void onAgreementTap(BuildContext context, AgreementListItem item) {
    FocusScope.of(context).unfocus();
    unawaited(
      context.router.push(
        AgreementRoute(
          agreementType: item.type.getValue,
          isRead: true,
        ),
      ),
    );
  }
}
