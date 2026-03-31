// مسار الملف: lib/features/commissions/views/widgets/filter_tabs_widget.dart

import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class FilterTabsWidget extends StatelessWidget {
  final List<String> tabKeys;
  final int selectedIndex;
  final Function(int) onTabChanged;

  const FilterTabsWidget({
    super.key,
    required this.tabKeys,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // محاذاة لليمين كما في التصميم
        children: List.generate(tabKeys.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTabChanged(index),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1CB0F6) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    context.tr(tabKeys[index]),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: Colors.white, size: 16),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
