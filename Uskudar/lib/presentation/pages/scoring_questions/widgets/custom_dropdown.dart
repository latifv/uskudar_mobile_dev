import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    required this.hintText,
    required this.controller,
    required this.items,
    required this.onChanged,
    required this.focusNode,
    this.prefixIcon,
    this.nextFocusNode,
    this.enableSearch = false,
    super.key,
  });

  final String hintText;
  final TextEditingController controller;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Icon? prefixIcon;
  final bool enableSearch;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDropdown(context),
      child: Container(
        height: context.dynamicHeight(.065),
        padding: context.paddingNormalHorizontal,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: context.borderRadiusLowAll,
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[prefixIcon!, context.spacingLowWidth],
            Expanded(
              child: Text(
                controller.text.isEmpty ? hintText : controller.text,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: controller.text.isEmpty
                      ? context.colorScheme.onSurface.withAlpha(100)
                      : context.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: context.colorScheme.onSurface.withAlpha(164),
              size: IconSizeConstants.n,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDropdown(BuildContext context) async {
    focusNode.requestFocus();
    final selectedValue = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalTop,
      ),
      constraints: BoxConstraints(maxHeight: context.dynamicHeight(.75)),
      builder: (context) {
        return _DropdownModal(
          hintText: hintText,
          items: items,
          controller: controller,
          enableSearch: enableSearch,
        );
      },
    );

    if (selectedValue != null) {
      final selectedItem = items.firstWhere(
        (item) => item.value == selectedValue,
        orElse: () => const DropdownMenuItem(value: '', child: Text('')),
      );

      final displayText = (selectedItem.child as Text).data ?? '';

      controller.text = displayText;
      onChanged(selectedValue);

      if (nextFocusNode != null) {
        nextFocusNode!.requestFocus();
      }
    }
  }
}

final class _DropdownModal extends StatefulWidget {
  const _DropdownModal({
    required this.hintText,
    required this.items,
    required this.controller,
    required this.enableSearch,
  });

  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final TextEditingController controller;
  final bool enableSearch;

  @override
  State<_DropdownModal> createState() => _DropdownModalState();
}

final class _DropdownModalState extends State<_DropdownModal> {
  late final TextEditingController _searchController;
  List<DropdownMenuItem<String>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        final itemText = (item.child as Text).data?.toLowerCase() ?? '';
        return itemText.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: context.paddingLowTop * 1.5,
            child: Container(
              width: context.dynamicWidth(.1),
              height: context.dynamicHeight(.005),
              decoration: BoxDecoration(
                color: context.colorScheme.onSurface.withAlpha(64),
                borderRadius: context.borderRadiusLowAll,
              ),
            ),
          ),
          Padding(
            padding: context.paddingNormalVertical,
            child: Text(
              widget.hintText,
              style: context.textTheme.displayMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          if (widget.enableSearch) ...[
            Padding(
              padding: context.paddingLowHorizontal,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: LocaleKeys.search_placeholder.translate,
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: IconSizeConstants.n,
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: context.borderRadiusLowAll,
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: context.borderRadiusLowAll,
                    borderSide: BorderSide(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                style: context.textTheme.bodyMedium,
              ),
            ),
            context.spacingLowHeight,
          ],
          Divider(
            height: 1,
            color: Colors.grey.shade600,
          ),
          SizedBox(
            height: context.dynamicHeight(.5),
            child: _filteredItems.isEmpty
                ? Center(
                    child: Padding(
                      padding: context.paddingNormalAll,
                      child: Text(
                        LocaleKeys.no_results_found.translate,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final itemValue = item.value ?? '';
                      final itemText = (item.child as Text).data ?? '';
                      final isSelected = widget.controller.text == itemText;
                      return InkWell(
                        onTap: () => Navigator.of(context).pop(itemValue),
                        child: Container(
                          padding: context.paddingNormalAll,
                          color: isSelected
                              ? context.colorScheme.onSurface.withAlpha(
                                  10,
                                )
                              : context.colorScheme.surface,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  itemText,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade700,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  color: context.colorScheme.onSurface,
                                  size: IconSizeConstants.n,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          context.spacingLowHeight,
        ],
      ),
    );
  }
}
