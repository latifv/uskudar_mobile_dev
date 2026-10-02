import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/faq/bloc/faq_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/faq/mixin/faq_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/faq/widgets/faq_item.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

final class _FaqScreenState extends State<FaqScreen> with FaqMixin {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFaqExpanded(int index) {
    toggleFaqExpanded(index);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && _scrollController.hasClients) {
        const itemHeight = 200.0;
        final targetOffset = index * itemHeight;

        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

        unawaited(
          _scrollController.animateTo(
            clampedOffset,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.faq.translate)),
      body: BlocBuilder<FaqBloc, FaqState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == FaqStatus.loading) {
            return const Center(child: CustomLoading());
          } else if (state.status == FaqStatus.error) {
            return Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadFaqData,
              ),
            );
          } else if (state.status == FaqStatus.loaded) {
            if (state.helps?.isEmpty ?? true) {
              return Center(
                child: CustomEmptyList(
                  iconData: Icons.help_outline,
                  title: LocaleKeys.faq_empty_list_title.translate,
                  description: LocaleKeys.faq_empty_list_description.translate,
                ),
              );
            }
            return SingleChildScrollView(
              controller: _scrollController,
              padding: context.paddingBaseLow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  context.spacingLowHeight,
                  _buildHeaderText(),
                  context.spacingNormalHeight,
                  _buildContent(state),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderText() {
    return Text(
      LocaleKeys.questions_description.translate,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withAlpha(200),
      ),
    );
  }

  Widget _buildContent(FaqState state) {
    return Column(
      children: List.generate(
        state.helps!.length,
        (index) {
          final help = state.helps![index];
          final isExpanded = state.expandStates[index] ?? false;

          if (!_itemKeys.containsKey(index)) {
            _itemKeys[index] = GlobalKey();
          }

          return FaqItem(
            key: _itemKeys[index],
            help: help,
            isExpanded: isExpanded,
            onTap: () => _toggleFaqExpanded(index),
          );
        },
      ),
    );
  }
}
