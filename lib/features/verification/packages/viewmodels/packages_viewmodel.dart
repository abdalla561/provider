// مسار الملف: lib/features/packages/viewmodels/packages_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/network/api_client.dart';
import '../../submit_verification/repositories/verification_repository.dart';
import '../../submit_verification/viewmodels/verification_viewmodel.dart';
import '../../submit_verification/views/submit_verification_view.dart';
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

  // 🚀 عند اختيار الباقة والانتقال لشاشة إرسال البيانات
  void selectPackage(BuildContext context, int packageId) {
    // الانتقال لشاشة إرسال التوثيق مع حقن الـ ViewModel والـ Repository الخاص بها
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => VerificationViewModel(
            VerificationRepository(context.read<ApiService>()),
          ),
          child: SubmitVerificationView(packageId: packageId),
        ),
      ),
    );
  }
}