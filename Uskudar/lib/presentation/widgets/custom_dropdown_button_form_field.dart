import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CustomDropdownButtonFormField<T> extends StatelessWidget {
  const CustomDropdownButtonFormField({
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.value,
    super.key,
  });

  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String hintText;
  final String? Function(T?)? validator;
  final T? value;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: context.borderRadiusLowAll,
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        borderRadius: context.borderRadiusLowAll,
        style: context.textTheme.bodyMedium,
        hint: Text(
          hintText,
          style: context.textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
        decoration: InputDecoration(
          hintStyle: context.textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
        items: items,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
