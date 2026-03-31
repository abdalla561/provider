// مسار الملف: lib/features/services/views/edit_service_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/core/utils/dialog_helper.dart';
import 'package:service_provider_app/features/services/models/service_details_model.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../../../core/storage/token_storage.dart';
import '../repositories/manage_services_repository.dart';
import '../viewmodels/edit_service_viewmodel.dart';
import 'dart:io';

class EditServiceView extends StatelessWidget {
  final ServiceDetailsModel service; // استقبال بيانات الخدمة

  const EditServiceView({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    // تجهيز الـ Repository لهذه الشاشة
    final tokenStorage = TokenStorage();
    final apiService = ApiService(tokenStorage);
    final repository = ManageServicesRepository(apiService);

    return ChangeNotifierProvider(
      create: (_) => EditServiceViewModel(
        repository,
        service,
      ), // استخدام الـ ViewModel الخاص بالتعديل
      child: _EditServiceBody(service: service),
    );
  }
}

class _EditServiceBody extends StatelessWidget {
  final ServiceDetailsModel service;
  const _EditServiceBody({required this.service});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<EditServiceViewModel>(context);

    // تجهيز عرض الصورة (الجديدة إن وجدت، وإلا القديمة إن وجدت)
    DecorationImage? imageDecoration;
    if (viewModel.imageFile != null) {
      imageDecoration = DecorationImage(
        image: FileImage(viewModel.imageFile!),
        fit: BoxFit.cover,
      );
    } else if (service.imageUrl.isNotEmpty) {
      imageDecoration = DecorationImage(
        image: NetworkImage(service.imageUrl),
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      backgroundColor: context.qsColors.background,
      appBar: AppBar(
        backgroundColor: context.qsColors.background,
        elevation: 0,
        centerTitle: true,
        // تأكد من إضافة 'edit_service' في ملفات الترجمة لديك
        title: Text(
          context.tr('edit_service') ?? 'تعديل الخدمة',
          style: TextStyle(
            color: context.qsColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.qsColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. تغيير الصورة
            // ==========================================
            GestureDetector(
              onTap: viewModel.pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.qsColors.textSub.withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  image: imageDecoration,
                ),
                // إذا لم يكن هناك صورة جديدة ولا صورة قديمة، اعرض الأيقونة
                child: (viewModel.imageFile == null && service.imageUrl.isEmpty)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: context.qsColors.textSub,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.tr('change_service_image') ??
                                'تغيير صورة الخدمة',
                            style: TextStyle(
                              color: context.qsColors.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.tr('recommended_image_size'),
                            style: TextStyle(
                              color: context.qsColors.textSub,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            // ==========================================
            // 2. عنوان القسم (تفاصيل الخدمة)
            // ==========================================
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.qsColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  context.tr('service_details'),
                  style: TextStyle(
                    color: context.qsColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ==========================================
            // 3. الحقول
            // ==========================================
            _buildLabel(context, context.tr('service_name')),
            _buildTextField(
              context,
              controller: viewModel.nameController,
              hint: context.tr('service_name_hint'),
            ),
            const SizedBox(height: 16),

            _buildLabel(context, context.tr('category')),
            _buildDropdown(context, viewModel),
            const SizedBox(height: 16),

            _buildLabel(context, context.tr('base_price')),
            _buildPriceField(context, viewModel.priceController),
            const SizedBox(height: 16),

            _buildLabel(context, context.tr('required_partial_percent')),
            _buildPercentField(context, viewModel.partialPercentController),
            const SizedBox(height: 16),

            _buildLabel(context, context.tr('service_description')),
            _buildTextField(
              context,
              controller: viewModel.descriptionController,
              hint: context.tr('service_description_hint'),
              maxLines: 4,
            ),

            const SizedBox(height: 40),

            // ==========================================
            // 4. زر حفظ التعديلات
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.qsColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        bool success = await viewModel.updateService(context);
                        if (success && context.mounted) {
                          await DialogHelper.showSuccessDialog(
                            context,
                            context.tr('service_updated_successfully') ??
                                'تم حفظ التعديلات بنجاح!',
                          );
                          // نرسل true للشاشة السابقة لتعرف أنه تم التحديث
                          Navigator.pop(context, true);
                        }
                      },
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            context.tr('save_changes') ?? 'حفظ التعديلات',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.save_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دوال مساعدة لرسم الحقول بتصميمك ---

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 4.0),
      child: Text(
        text,
        style: TextStyle(
          color: context.qsColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: context.qsColors.textSub.withOpacity(0.5),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, EditServiceViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
      ),
      child: viewModel.isLoadingCategories
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          : DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: viewModel.selectedCategoryId,
                hint: Text(
                  context.tr('choose_category'),
                  style: TextStyle(
                    color: context.qsColors.textSub.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.qsColors.textSub,
                ),
                items: viewModel.categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: TextStyle(color: context.qsColors.text),
                    ),
                  );
                }).toList(),
                onChanged: viewModel.setCategory,
              ),
            ),
    );
  }

  Widget _buildPriceField(
    BuildContext context,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  color: context.qsColors.textSub.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: context.qsColors.textSub.withOpacity(0.1),
                ),
              ),
            ),
            child: Text(
              context.tr('currency_sar') ?? 'ر.س',
              style: TextStyle(
                color: context.qsColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentField(
    BuildContext context,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '40',
                hintStyle: TextStyle(
                  color: context.qsColors.textSub.withOpacity(0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: context.qsColors.textSub.withOpacity(0.1),
                ),
              ),
            ),
            child: Text(
              '%',
              style: TextStyle(
                color: context.qsColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
