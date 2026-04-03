// مسار الملف: lib/features/withdraw/views/withdraw_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/core/localization/app_localizations.dart';
import 'package:service_provider_app/core/theme/qs_color_extension.dart';
import 'package:service_provider_app/core/utils/dialog_helper.dart';
import '../viewmodels/withdraw_viewmodel.dart';

class WithdrawView extends StatefulWidget {
  final int availablePoints;

  const WithdrawView({super.key, required this.availablePoints});

  @override
  State<WithdrawView> createState() => _WithdrawViewState();
}

class _WithdrawViewState extends State<WithdrawView> {
  final _amountController = TextEditingController();

  Future<void> _handleWithdraw(WithdrawViewModel viewModel) async {
    final String amountStr = _amountController.text.trim();
    if (amountStr.isEmpty) return;

    final double? amount = double.tryParse(amountStr);
    if (amount == null) return;

    final success = await viewModel.validateAndSubmit(
      amount: amount,
      availablePoints: widget.availablePoints,
    );

    if (success && mounted) {
      await DialogHelper.showSuccessDialog(
        context,
        context.tr('withdrawal_request_sent'),
      );
      if (mounted) {
        Navigator.pop(context); // العودة لصفحة العمولات
      }
    } else if (mounted && viewModel.errorMessage != null) {
      DialogHelper.showErrorDialog(context, context.tr(viewModel.errorMessage!));
      viewModel.clearError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.qsColors;
    final viewModel = context.watch<WithdrawViewModel>();
    final Color primaryColor = const Color(0xFF1CB0F6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('withdraw_points'),
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: colors.text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        leading: const SizedBox.shrink(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 💳 كرت الرصيد المتاح
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    context.tr('available_balance'),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.availablePoints}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.tr('pts'),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 💰 حقل إدخال المبلغ
            Text(
              context.tr('withdraw_amount'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: context.tr('enter_amount'),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF1CB0F6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // 🔘 زر التأكيد
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: viewModel.isLoading ? null : () => _handleWithdraw(viewModel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        context.tr('withdraw_points'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
