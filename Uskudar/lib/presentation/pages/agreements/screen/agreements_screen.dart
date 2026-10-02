import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/agreements/mixin/agreements_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/agreements/widgets/agreement_list_tile.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';

@RoutePage()
final class AgreementsScreen extends StatefulWidget {
  const AgreementsScreen({super.key});

  @override
  State<AgreementsScreen> createState() => _AgreementsScreenState();
}

final class _AgreementsScreenState extends State<AgreementsScreen>
    with AgreementsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.agreements_and_policies.translate),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding:
              context.paddingMediumHorizontal + context.paddingNormalVertical,
          children: [
            Text(
              LocaleKeys.agreements_and_policies_description.translate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            context.spacingMediumHeight,
            for (var index = 0; index < agreements.length; index++) ...[
              AgreementListTile(
                titleKey: agreements[index].titleKey,
                icon: agreements[index].icon,
                onTap: () => onAgreementTap(context, agreements[index]),
              ),
              if (index != agreements.length - 1) context.spacingLowHeight,
            ],
          ],
        ),
      ),
    );
  }
}
