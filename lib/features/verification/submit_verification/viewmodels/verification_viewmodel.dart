// مسار الملف: lib/features/verification/viewmodels/verification_viewmodel.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repositories/verification_repository.dart';
import '../../../../core/localization/app_localizations.dart';

class VerificationViewModel extends ChangeNotifier {
  final VerificationRepository repository;

  VerificationViewModel(this.repository);

  File? selectedImage;
  final TextEditingController bondNumberController = TextEditingController();

  bool isLoading = false;

  // 📸 اختيار الصورة من المعرض
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // 🗑️ حذف الصورة المحددة
  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  // 🚀 إرسال الطلب للسيرفر
  Future<void> submitVerification(BuildContext context, int packageId) async {
    if (selectedImage == null) {
      _showSnackBar(context, context.tr('upload_image_validation'), Colors.red);
      return;
    }
    if (bondNumberController.text.trim().isEmpty) {
      _showSnackBar(
        context,
        context.tr('enter_bond_number_validation'),
        Colors.red,
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await repository.submitVerificationPackage(
        packageId: packageId,
        bondNumber: bondNumberController.text.trim(),
        imageBond: selectedImage!,
      );

      isLoading = false;
      notifyListeners();

      _showSnackBar(
        context,
        context.tr('verification_submitted_success'),
        Colors.green,
      );

      // العودة للصفحة السابقة بعد النجاح
      Navigator.pop(context);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      _showSnackBar(context, e.toString(), Colors.red);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: color,
      ),
    );
  }

  @override
  void dispose() {
    bondNumberController.dispose();
    super.dispose();
  }
}
