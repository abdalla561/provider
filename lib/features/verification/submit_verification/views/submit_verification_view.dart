import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/core/localization/app_localizations.dart';
import 'package:service_provider_app/core/theme/qs_color_extension.dart';

import '../viewmodels/verification_viewmodel.dart';

class SubmitVerificationView extends StatelessWidget {
  final int packageId; // 🚀 استقبال رقم الباقة من الشاشة السابقة

  const SubmitVerificationView({super.key, required this.packageId});

  @override
  Widget build(BuildContext context) {
    final colors = context.qsColors;
    final vm = context.watch<VerificationViewModel>();
    final bgColor = const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('verify_account_title'),
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colors.text, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // 📝 1. الهيدر (العنوان والوصف)
            _buildHeader(context, colors),
            const SizedBox(height: 40),

            // 📸 2. قسم رفع الصورة (صورة السند)
            _buildSectionTitle(
              context,
              Icons.contact_mail_rounded,
              context.tr('bond_image_title'),
              colors,
            ),
            const SizedBox(height: 16),
            _buildImageUploadArea(context, vm, colors),
            const SizedBox(height: 32),

            // 🔢 3. قسم إدخال رقم السند
            _buildSectionTitle(
              context,
              Icons.receipt_long_rounded,
              context.tr('bond_number_title'),
              colors,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              vm.bondNumberController,
              context.tr('bond_number_hint'),
              colors,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomSection(context, vm, colors),
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    VerificationViewModel vm,
    dynamic colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, color: Color(0xFF9CA3AF), size: 16),
                const SizedBox(width: 6),
                Text(
                  context.tr('data_encrypted_secure'),
                  style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: vm.isLoading ? null : () => vm.submitVerification(context, packageId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5CA4B8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: vm.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('submit_for_review'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic colors) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF5CA4B8).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 32,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF5CA4B8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF5CA4B8).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          context.tr('verify_identity_heading'),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.text),
        ),
        const SizedBox(height: 12),
        Text(
          context.tr('verify_identity_desc'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colors.textSub, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title, dynamic colors) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5CA4B8), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.text),
        ),
      ],
    );
  }

  Widget _buildImageUploadArea(BuildContext context, VerificationViewModel vm, dynamic colors) {
    if (vm.selectedImage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(vm.selectedImage!, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('صورة السند', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('تم الرفع بنجاح', style: TextStyle(color: Colors.green.shade600, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => vm.removeImage(),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () => vm.pickImage(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(color: Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF6B7280), size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('click_to_upload_bond'),
              style: const TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller, String hint, dynamic colors) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: colors.textSub, fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
