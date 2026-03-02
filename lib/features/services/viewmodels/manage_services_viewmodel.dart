// مسار الملف: lib/features/services/viewmodels/manage_services_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:service_provider_app/core/network/error/failure.dart';
import '../models/manage_services_model.dart';
import '../repositories/manage_services_repository.dart';

class ManageServicesViewModel extends ChangeNotifier {
  final ManageServicesRepository _repository;

  ManageServicesViewModel(this._repository) {
    fetchServices();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ServiceModel> _allServices = [];
  
  // 0=الكل, 1=نشط, 2=مسودة, 3=موقوف
  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  // إرجاع القائمة المفلترة بناءً على التبويب المختار
  List<ServiceModel> get filteredServices {
    if (_selectedFilterIndex == 0) return _allServices;
    
    String statusFilter = '';
    if (_selectedFilterIndex == 1) statusFilter = 'نشط';
    if (_selectedFilterIndex == 2) statusFilter = 'مسودة';
    if (_selectedFilterIndex == 3) statusFilter = 'موقوف';

    return _allServices.where((s) => s.status == statusFilter).toList();
  }

  void changeFilter(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
  }

  Future<void> fetchServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allServices = await _repository.getServices();
      _isLoading = false;
      notifyListeners();
    } on Failure catch (failure) {
      _isLoading = false;
      _errorMessage = failure.message;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'حدث خطأ غير متوقع';
      notifyListeners();
    }
  }
}