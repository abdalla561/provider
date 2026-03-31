// مسار الملف: lib/features/commissions/views/commissions_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../viewmodels/commissions_viewmodel.dart';
import 'widgets/verification_banner_widget.dart';
import 'widgets/due_commission_card.dart';
import 'widgets/filter_tabs_widget.dart';
import 'widgets/transaction_list_item.dart';

class CommissionsView extends StatelessWidget {
  const CommissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    // نفترض أن ViewModel تم توفيره عبر Provider (مثلاً في main.dart)
    final viewModel = Provider.of<CommissionsViewModel>(context);

    // لون الخلفية الرمادي الفاتح جداً
    final Color bgColor = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('commissions_management'),
          style: TextStyle(
            color: context.qsColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          // سهم الرجوع مناسب للغة العربية (لليمين)
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: context.qsColors.text),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ],
        // إزالة زر القائمة الجانبية إذا كان موجوداً لتطابق الصورة تماماً
        leading: const SizedBox.shrink(),
      ),
      body: RefreshIndicator(
        onRefresh: () async => await viewModel.fetchCommissionsData(),
        color: const Color(0xFF1CB0F6),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. شريط توثيق الحساب (في حال لم يكن الحساب موثقاً)
              if (viewModel.commissionsData?.summary.isVerified == false || viewModel.commissionsData == null) ...[
                const VerificationBannerWidget(),
                const SizedBox(height: 24),
              ],

              // 2. بطاقة العمولة المستحقة
              // (في حالة الانتظار أو الخطأ، نظهر صفر أو لا شيء، ولكن بما أنه تصميم يجب إظهاره دائماً)
              DueCommissionCard(
                amount: viewModel.commissionsData?.summary.dueAmount ?? 0.0,
              ),
              const SizedBox(height: 32),

              // 3. قسم سجل المدفوعات (العنوان + التبويبات)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // TODO: عرض سجل كامل أو صفحة منفصلة
                    },
                    child: Text(
                      context.tr('view_all'),
                      style: const TextStyle(
                        color: Color(0xFF1CB0F6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    context.tr('payments_history'),
                    style: TextStyle(
                      color: context.qsColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // التبويبات (الكل، مدفوع، معلق)
              FilterTabsWidget(
                tabKeys: viewModel.tabKeys,
                selectedIndex: viewModel.selectedTabIndex,
                onTabChanged: viewModel.changeTab,
              ),
              const SizedBox(height: 24),

              // 4. قائمة العمليات 
              // التحقق من حالة التحميل أو الخطأ
              if (viewModel.isLoading && viewModel.filteredTransactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(color: Color(0xFF1CB0F6)),
                  ),
                )
              else if (viewModel.errorMessage != null && viewModel.filteredTransactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, size: 50, color: Colors.red.shade400),
                        const SizedBox(height: 16),
                        Text(
                          context.tr(viewModel.errorMessage!),
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (viewModel.filteredTransactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      context.tr('no_transactions_currently'),
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                )
              else
                ...viewModel.filteredTransactions.map((transaction) {
                  return TransactionListItem(transaction: transaction);
                }),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
