import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/core/localization/app_localizations.dart';
import 'package:service_provider_app/features/commissions/viewmodels/payments_history_viewmodel.dart';
import 'package:service_provider_app/features/commissions/views/widgets/history_list_item.dart';

class PaymentsHistorySection extends StatelessWidget {
  const PaymentsHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentsHistoryViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
            Text(
              context.tr('payments_history'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // التبويبات الـ 5 (الكل، باقاتي، العمليات، السحوبات، السندات)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(viewModel.tabKeys.length, (index) {
                  bool isSelected = viewModel.selectedTabIndex == index;
                  return GestureDetector(
                    onTap: () => viewModel.changeTab(index),
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2196F3) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? Colors.transparent : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        context.tr(viewModel.tabKeys[index]),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // قائمة سجل العمليات
            if (viewModel.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (viewModel.errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(context.tr(viewModel.errorMessage!)),
                ),
              )
            else if (viewModel.filteredHistory.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Column(
                    children: [
                      Icon(Icons.history_rounded, size: 48, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text(
                        context.tr('no_transactions_currently'),
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.filteredHistory.length,
                itemBuilder: (context, index) {
                  return HistoryListItem(item: viewModel.filteredHistory[index]);
                },
              ),
          ],
        );
      },
    );
  }
}
