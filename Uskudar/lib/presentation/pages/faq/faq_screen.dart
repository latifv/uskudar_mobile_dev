import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/help.dart';
import 'package:uskudar_mobile/presentation/pages/faq/widgets/faq_item.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';

@RoutePage()
final class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The shared payment API serves another brand's FAQ. This demo displays
    // reviewed municipality copy until a dedicated content source is ready.
    final helps = context.locale.languageCode == 'en'
        ? _englishFaqs
        : _turkishFaqs;

    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.faq.translate)),
      body: ListView(
        padding: context.paddingBaseLow,
        children: [
          context.spacingLowHeight,
          Text(
            LocaleKeys.questions_description.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(200),
            ),
          ),
          context.spacingNormalHeight,
          for (final help in helps)
            FaqItem(help: help, isExpanded: false, onTap: () {}),
        ],
      ),
    );
  }
}

const _turkishFaqs = <Help>[
  Help(
    id: 1,
    title: 'Üsküdar Belediyesi uygulamasında neler yapabilirim?',
    content:
        '<p>Kartlarınızı görüntüleyebilir, para transferi yapabilir, fatura ödeyebilir ve işlemlerinizi takip edebilirsiniz.</p>',
  ),
  Help(
    id: 2,
    title: 'Uygulamaya nasıl giriş yaparım?',
    content:
        '<p>Kayıtlı telefon numaranız ve şifrenizle giriş yapın. İstenirse telefonunuza gelen doğrulama kodunu girin.</p>',
  ),
  Help(
    id: 3,
    title: 'Şifremi unuttum, nasıl yenileyebilirim?',
    content:
        '<p>Giriş ekranındaki Şifremi Unuttum seçeneğini kullanarak şifrenizi yenileyebilirsiniz.</p>',
  ),
  Help(
    id: 4,
    title: 'Hesabımı nasıl doğrulayabilirim?',
    content:
        '<p>Uygulamadaki hesap doğrulama adımlarını izleyin. Kimlik ve yüz doğrulaması istenirse ekrandaki yönlendirmeleri takip edin.</p>',
  ),
  Help(
    id: 5,
    title: 'Kartlarımı nerede görebilirim?',
    content:
        '<p>Ana sayfadaki Kartlarım alanından veya menüdeki Kartlarım seçeneğinden kartlarınıza ulaşabilirsiniz.</p>',
  ),
  Help(
    id: 6,
    title: 'Kart bilgilerimi nasıl görüntülerim?',
    content:
        '<p>Kartlarım bölümünden kartınızı seçin. Kart numarası ve güvenlik kodu için kart detayındaki görünürlük simgelerini kullanın.</p>',
  ),
  Help(
    id: 7,
    title: 'Kartımı nasıl yönetebilirim?',
    content:
        '<p>Kart detayında kullanılabilir durum, güvenlik ve işlem seçeneklerini görüntüleyebilirsiniz.</p>',
  ),
  Help(
    id: 8,
    title: 'Başka bir kullanıcıya nasıl para gönderirim?',
    content:
        '<p>Para Gönder bölümünü açın, alıcı bilgilerini girin ve onay ekranındaki işlem detaylarını kontrol edin.</p>',
  ),
  Help(
    id: 9,
    title: 'İşlem geçmişimi nerede görebilirim?',
    content:
        '<p>İşlem geçmişi bölümünden transfer ve ödeme kayıtlarınızı inceleyebilirsiniz.</p>',
  ),
  Help(
    id: 10,
    title: 'Fatura ödemesini nasıl yaparım?',
    content:
        '<p>Fatura Öde bölümünde kurum ve abone bilgilerini girerek ödeme adımlarını izleyin.</p>',
  ),
  Help(
    id: 11,
    title: 'İşlem ücretlerini ve limitleri nerede görebilirim?',
    content:
        '<p>Uygulamadaki Komisyon Oranları ve İşlem Limitleri bölümlerini kontrol edin. İşlemi onaylamadan önce ekrandaki tutarı inceleyin.</p>',
  ),
  Help(
    id: 12,
    title: 'Bir işlemle ilgili yardıma nasıl ulaşabilirim?',
    content:
        '<p>Menüdeki Bize Ulaşın bölümünde güncel telefon ve e-posta bilgilerini bulabilirsiniz.</p>',
  ),
];

const _englishFaqs = <Help>[
  Help(
    id: 1,
    title: 'What can I do in the Üsküdar Municipality app?',
    content:
        '<p>You can view your cards, transfer money, pay bills, and review your transactions.</p>',
  ),
  Help(
    id: 2,
    title: 'How do I sign in?',
    content:
        '<p>Sign in with your registered phone number and password. Enter the verification code sent to your phone if prompted.</p>',
  ),
  Help(
    id: 3,
    title: 'How can I reset my password?',
    content: '<p>Use the Forgot Password option on the sign-in screen.</p>',
  ),
  Help(
    id: 4,
    title: 'How do I verify my account?',
    content:
        '<p>Follow the account verification steps in the app. Complete identity and face verification if requested.</p>',
  ),
  Help(
    id: 5,
    title: 'Where can I find my cards?',
    content: '<p>Open My Cards on the home screen or in the menu.</p>',
  ),
  Help(
    id: 6,
    title: 'How can I view my card details?',
    content:
        '<p>Select a card in My Cards. Use the visibility icons on the card details screen to reveal the card number or security code.</p>',
  ),
  Help(
    id: 7,
    title: 'How can I manage my card?',
    content:
        '<p>Open the card details screen to see its status, security settings, and available actions.</p>',
  ),
  Help(
    id: 8,
    title: 'How do I send money to another user?',
    content:
        '<p>Open Send Money, enter the recipient details, and review the transaction before confirming.</p>',
  ),
  Help(
    id: 9,
    title: 'Where can I see my transaction history?',
    content:
        '<p>Open Transaction History to review transfers and payments.</p>',
  ),
  Help(
    id: 10,
    title: 'How do I pay a bill?',
    content:
        '<p>Open Pay Bills, enter the provider and account details, and follow the payment steps.</p>',
  ),
  Help(
    id: 11,
    title: 'Where can I see fees and limits?',
    content:
        '<p>Check the Fees and Transaction Limits sections. Review the amount shown before confirming a transaction.</p>',
  ),
  Help(
    id: 12,
    title: 'How can I get help with a transaction?',
    content:
        '<p>Open Contact Us in the menu for current phone and email details.</p>',
  ),
];
