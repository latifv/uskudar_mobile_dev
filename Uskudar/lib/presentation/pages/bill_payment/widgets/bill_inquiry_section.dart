import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/bill_product.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_query_definition.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

final class BillInquirySection extends StatelessWidget {
  const BillInquirySection({
    required this.selectedProduct,
    required this.productQueryDefinitions,
    required this.subscriberControllers,
    required this.onInquiry,
    required this.onGoBack,
    required this.isLoading,
    super.key,
  });

  final BillProduct selectedProduct;
  final List<BillProductQueryDefinition> productQueryDefinitions;
  final Map<String, TextEditingController> subscriberControllers;
  final Future<void> Function() onInquiry;
  final VoidCallback onGoBack;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onGoBack,
              icon: const Icon(
                Icons.arrow_back,
                size: IconSizeConstants.m,
              ),
            ),
            context.spacingLowWidth,
            Expanded(
              child: Text(
                LocaleKeys.bill_inquiry.translate,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        context.spacingNormalHeight,
        Center(
          child: CircleAvatar(
            radius: IconSizeConstants.xl,
            backgroundColor: context.colorScheme.primary.withValues(
              alpha: 0.05,
            ),
            child: Icon(
              Icons.business,
              color: context.colorScheme.primary,
              size: IconSizeConstants.xl,
            ),
          ),
        ),
        context.spacingNormalHeight,
        Center(
          child: Text(
            LocaleKeys.selected_institution.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Center(
          child: Text(
            selectedProduct.productName,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        context.spacingNormalHeight,
        ...productQueryDefinitions.map((definition) {
          final controller =
              subscriberControllers[definition.subcriberNumberKeySizeOrder];
          if (controller == null) return const SizedBox.shrink();

          return Padding(
            padding: EdgeInsets.only(
              bottom: context.spacingNormalHeight.height ?? 16,
            ),
            child: CustomTextFormField(
              hintText: definition.subcriberNumberLabel,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
            ),
          );
        }),
        SizedBox(
          width: double.infinity,
          child: SurfaceElevatedButton(
            text: LocaleKeys.inquiry_bill.translate,
            onPressed: isLoading ? () {} : onInquiry,
          ),
        ),
        context.spacingNormalHeight,
        ListTile(
          leading: Icon(
            Icons.info_outline,
            color: context.colorScheme.primary,
          ),
          title: Text(
            LocaleKeys.bill_inquiry_info.translate,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          contentPadding: context.paddingLowHorizontal,
        ),
      ],
    );
  }
}
