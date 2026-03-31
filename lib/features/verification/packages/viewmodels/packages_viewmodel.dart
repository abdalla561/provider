// مسار الملف: lib/features/packages/viewmodels/packages_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/package_model.dart';
import '../repositories/packages_repository.dart'; // 🚀 مسحنا كلمة hide من هنا

class PackagesViewModel extends ChangeNotifier {
  final PackagesRepository repository;

  PackagesViewModel(this.repository) {
    fetchPackages(); // جلب البيانات بمجرد فتح الشاشة
  }

  bool isLoading = false;
  String? errorMessage;
  List<PackageModel> packages = [];

  // 🚀 مسحنا سطر isPopular الخاطئ من هنا لأنه ينتمي للمودل وليس هنا

  // 📥 جلب الباقات من السيرفر
  Future<void> fetchPackages() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners(); 

    try {
      packages = await repository.getPackages();
    } catch (e) {
      errorMessage = 'error_loading_packages';
    } finally {
      isLoading = false;
      notifyListeners(); 
    }
  }

  // 🚀 عند اختيار الباقة 
  void selectPackage(BuildContext context, int packageId) {
    print('تم اختيار الباقة من السيرفر رقم: $packageId');
  }
}