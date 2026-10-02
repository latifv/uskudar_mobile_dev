import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/domain/validators/app_validators.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/phone_number_text_form_field.dart';

final class RecipientInputSection extends StatelessWidget {
  const RecipientInputSection({
    required this.transferMethod,
    required this.phoneController,
    required this.walletController,
    required this.formKey,
    this.onSelectFromContacts,
    this.onQrScanPressed,
    super.key,
  });

  final TransferMethod transferMethod;
  final TextEditingController phoneController;
  final TextEditingController walletController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onSelectFromContacts;
  final VoidCallback? onQrScanPressed;

  @override
  Widget build(BuildContext context) {
    if (transferMethod == TransferMethod.phone) {
      return _buildPhoneInputs(context);
    } else if (transferMethod == TransferMethod.wallet) {
      return _buildWalletInputs(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildPhoneInputs(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.receiver.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          context.spacingNormalHeight,
          PhoneNumberTextFormField(phoneNumberController: phoneController),
          context.spacingLowHeight,
          _buildContactSelectorCard(context),
        ],
      ),
    );
  }

  Widget _buildContactSelectorCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(color: context.colorScheme.outline.withAlpha(102)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelectFromContacts,
          borderRadius: context.borderRadiusLowAll,
          child: Padding(
            padding: context.paddingNormalAll,
            child: Row(
              children: [
                Container(
                  padding: context.paddingLowAll,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withAlpha(51),
                    borderRadius: context.borderRadiusLowAll,
                  ),
                  child: Icon(
                    Icons.contacts_rounded,
                    color: context.colorScheme.primary,
                    size: IconSizeConstants.n,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.select_from_contacts.translate,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      context.spacingLowHeight,
                      Text(
                        LocaleKeys.select_from_contacts_description.translate,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.colorScheme.onSurface.withAlpha(153),
                  size: IconSizeConstants.s,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletInputs(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.receiver.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          context.spacingNormalHeight,
          CustomTextFormField(
            controller: walletController,
            hintText: LocaleKeys.enter_wallet_address.translate,
            keyboardType: TextInputType.number,
            validator: (value) => AppValidators.required(
              value,
              LocaleKeys.warning_enter_wallet_address.translate,
            ),
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
          ),
          context.spacingLowHeight,
          _buildQrScanCard(context),
        ],
      ),
    );
  }

  Widget _buildQrScanCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(color: context.colorScheme.outline.withAlpha(102)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onQrScanPressed,
          borderRadius: context.borderRadiusLowAll,
          child: Padding(
            padding: context.paddingNormalAll,
            child: Row(
              children: [
                Container(
                  padding: context.paddingLowAll,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withAlpha(51),
                    borderRadius: context.borderRadiusLowAll,
                  ),
                  child: Icon(
                    Icons.qr_code_scanner_outlined,
                    color: context.colorScheme.primary,
                    size: IconSizeConstants.n,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.qr_scan_for_transfer.translate,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      context.spacingLowHeight,
                      Text(
                        LocaleKeys.qr_scan_for_transfer_description.translate,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.colorScheme.onSurface.withAlpha(153),
                  size: IconSizeConstants.s,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
