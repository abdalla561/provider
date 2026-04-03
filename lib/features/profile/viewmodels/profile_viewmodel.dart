// مسار الملف: lib/features/profile/viewmodels/profile_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/work_model.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileViewModel(this.repository) {
    fetchProfile(); // جلب البيانات عند التهيئة
  }

  bool isLoading = false;
  String? errorMessage;
  ProfileModel? profile;
  List<WorkModel> works = [];

  // جلب بيانات الملف الشخصي
  Future<void> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await repository.getMyProfile();
    } catch (e) {
      debugPrint('❌ ProfileViewModel fetchProfile error: $e');
      errorMessage = e.toString();
    }

    try {
      works = await repository.getPreviousWorks(); // 🚀 جلب الأعمال السابقة بشكل منضبط
    } catch (e) {
      debugPrint('❌ ProfileViewModel fetchWorks error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // دالة مساعدة للتحقق مما إذا كان المزود موثقاً حالياً
  bool get isCurrentlyVerified {
    if (profile == null) return false;
    if (!profile!.verificationProvider) return false;
    if (profile!.providerVerifiedUntil == null) return false;
    
    return profile!.providerVerifiedUntil!.isAfter(DateTime.now());
  }

  // حساب إجمالي النقاط (المدفوعة + المكافأة)
  double get totalPoints => (profile?.bonusPoints ?? 0) + (profile?.paidPoints ?? 0);
}