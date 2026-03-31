// مسار الملف: lib/features/profile/viewmodels/profile_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileViewModel(this.repository) {
    fetchProfile();
  }

  bool isLoading = false;
  String? errorMessage;
  ProfileModel? profile;

  Future<void> fetchProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      profile = await repository.getMyProfile();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}