// مسار الملف: lib/features/commissions/views/pay_with_receipt_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../../../core/utils/dialog_helper.dart';
import '../viewmodels/pay_commissions_viewmodel.dart';

class PayWithReceiptView extends StatelessWidget {
  const PayWithReceiptView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PayCommissionsViewModel>(context);
    final Color bgColor = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('attach_payment_receipt'),
          style: TextStyle(
            color: context.qsColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.qsColors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. بطاقة المعلومات العلوية
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.tr('receipt_upload_title'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5CA4B8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.tr('receipt_upload_subtitle'),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // الخط الأزرق الجانبي
                      Container(
                        width: 4,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5CA4B8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. منطقة رفع السند (Dashed Box)
                InkWell(
                  onTap: () => viewModel.pickReceiptImage(),
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: viewModel.receiptImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(viewModel.receiptImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE4F3F8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.cloud_upload_rounded, color: Color(0xFF5CA4B8), size: 32),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.tr('click_to_upload_receipt'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.tr('upload_limit_hint'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 32),

                // 3. الحقول (request_id, bond_number, description)

                // حقل رقم الطلب (request_id)
                _buildInputLabel(context.tr('request_id')),
                _buildTextField(
                  context,
                  controller: viewModel.requestIdController,
                  hint: context.tr('request_id_hint'),
                  icon: Icons.confirmation_number_rounded,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                // حقل رقم السند (bond_number)
                _buildInputLabel(context.tr('bond_number')),
                _buildTextField(
                  context,
                  controller: viewModel.bondNumberController,
                  hint: context.tr('bond_number_hint'),
                  icon: Icons.receipt_long_rounded,
                ),

                const SizedBox(height: 20),

                // حقل الوصف (description)
                _buildInputLabel(context.tr('description')),
                _buildTextField(
                  context,
                  controller: viewModel.descriptionController,
                  hint: context.tr('description_hint'),
                  icon: Icons.notes_rounded,
                  maxLines: 4,
                ),

                const SizedBox(height: 32),

                // Footer (Secure Payment)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 1, width: 40, color: Colors.grey.shade200),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            context.tr('secure_payment_footer'),
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade400, letterSpacing: 1),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.verified_user_rounded, color: Colors.grey.shade300, size: 14),
                        ],
                      ),
                    ),
                    Container(height: 1, width: 40, color: Colors.grey.shade200),
                  ],
                ),
                const SizedBox(height: 100), // Space for button
              ],
            ),
          ),

          // الزر السفلي
          Positioned(
            left: 24,
            right: 24,
            bottom: 30,
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        final success = await viewModel.submitReceipt();
                        if (context.mounted) {
                          if (success) {
                            await DialogHelper.showSuccessDialog(
                              context,
                              context.tr('payment_success'),
                            );
                            if (context.mounted) Navigator.pop(context);
                          } else if (viewModel.errorMessage != null) {
                            DialogHelper.showErrorDialog(
                              context,
                              context.tr(viewModel.errorMessage!),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CA4B8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('send_receipt'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.send_rounded, size: 24),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 4),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey.shade300, size: 22),
          suffixIcon: suffix != null ? Padding(padding: const EdgeInsets.all(12), child: suffix) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
