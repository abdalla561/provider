// مسار الملف: lib/features/points/viewmodels/points_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/points_package_model.dart';
import '../repositories/points_repository.dart';

class PointsViewModel extends ChangeNotifier {
  final PointsRepository _repository;

  PointsViewModel(this._repository);

  List<PointsPackageModel> _packages = [];
  List<PointsPackageModel> get packages => _packages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // 📥 جلب باقات شحن النقاط
  Future<void> fetchPointsPackages() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _packages = await _repository.getPointsPackages();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🚀 إرسال طلب اشتراك وسداد
  Future<bool> subscribeToPackage({
    required int packageId,
    required String bondNumber,
    required String bankName,
    required dynamic bondImage, // File
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.subscribeToPackage(
        packageId: packageId,
        bondNumber: bondNumber,
        bankName: bankName,
        bondImage: bondImage,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
