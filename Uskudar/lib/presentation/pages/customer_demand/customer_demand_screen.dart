import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/customer_demand_subject.dart';
import 'package:uskudar_mobile/presentation/pages/customer_demand/bloc/customer_demand_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/customer_demand/mixin/customer_demand_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dropdown_button_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class CustomerDemandScreen extends StatefulWidget {
  const CustomerDemandScreen({super.key});

  @override
  State<CustomerDemandScreen> createState() => _CustomerDemandScreenState();
}

final class _CustomerDemandScreenState extends State<CustomerDemandScreen>
    with CustomerDemandMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<CustomerDemandBloc, CustomerDemandState>(
        listener: blocListener,
        builder: (_, state) {
          return Scaffold(
            appBar: CustomAppBar(
              title: Text(LocaleKeys.customer_demand_title.translate),
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(CustomerDemandState state) {
    if (state.status == CustomerDemandStatus.initial ||
        state.status == CustomerDemandStatus.loading) {
      return const Center(child: CustomLoading());
    }

    if (state.status == CustomerDemandStatus.error && state.subjects.isEmpty) {
      return ErrorTryAgain(
        message: state.message ?? '',
        onTryAgain: () => bloc.add(const CustomerDemandLoadSubjects()),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: context.paddingBase,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.spacingNormalHeight,
              _buildDescription(),
              context.spacingMediumHeight,
              _buildSubjectDropdown(state.subjects),
              context.spacingNormalHeight,
              _buildTitleInput(),
              context.spacingNormalHeight,
              _buildContentInput(),
              context.spacingHighHeight,
              _buildSubmitButton(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      LocaleKeys.customer_demand_description.translate,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withAlpha(200),
      ),
    );
  }

  Widget _buildSubjectDropdown(List<CustomerDemandSubject> subjects) {
    return CustomDropdownButtonFormField<int>(
      value: selectedSubject?.key,
      hintText: LocaleKeys.customer_demand_subject.translate,
      items: subjects
          .map(
            (s) => DropdownMenuItem<int>(value: s.key, child: Text(s.value)),
          )
          .toList(),
      onChanged: (key) {
        if (key == null) return;
        final subject = subjects.firstWhere((s) => s.key == key);
        onSubjectChanged(subject);
      },
      validator: (value) {
        if (value == null) {
          return LocaleKeys.customer_demand_select_subject.translate;
        }
        return null;
      },
    );
  }

  Widget _buildTitleInput() {
    return CustomTextFormField(
      controller: titleController,
      focusNode: titleFocusNode,
      hintText: LocaleKeys.customer_demand_title_hint.translate,
      onFieldSubmitted: (_) => contentFocusNode.requestFocus(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.required_field.translate;
        }
        return null;
      },
    );
  }

  Widget _buildContentInput() {
    return CustomTextFormField(
      controller: contentController,
      focusNode: contentFocusNode,
      hintText: LocaleKeys.customer_demand_content_hint.translate,
      maxLines: 5,
      minLines: 3,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onSubmitPressed(),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.required_field.translate;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(CustomerDemandState state) {
    if (state.status == CustomerDemandStatus.submitting) {
      return const Center(child: CustomLoading());
    }
    return PrimaryElevatedButton(
      focusNode: submitFocusNode,
      onPressed: onSubmitPressed,
      text: LocaleKeys.send.translate,
    );
  }
}
