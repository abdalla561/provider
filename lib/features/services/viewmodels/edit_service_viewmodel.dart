// مسار الملف: lib/features/services/viewmodels/edit_service_viewmodel.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_app/core/network/error/failure.dart';
import 'package:service_provider_app/core/utils/dialog_helper.dart';
import 'package:service_provider_app/features/services/models/service_details_model.dart';
import '../repositories/manage_services_repository.dart';
import '../models/category_model.dart';

class EditServiceViewModel extends ChangeNotifier {
  final ManageServicesRepository _repository;
  final ServiceDetailsModel service;

  EditServiceViewModel(this._repository, this.service) {
    _initData();
    fetchCategories();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;
  bool _isLoadingCategories = false;
  bool get isLoadingCategories => _isLoadingCategories;

  File? _imageFile;
  File? get imageFile => _imageFile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 🚀 تعبئة الحقول ببيانات الخدمة الحالية
  void _initData() {
    nameController.text = service.title;
    descriptionController.text = service.description;
    // priceController.text = service.priceText.replaceAll(RegExp(r'[^0-9.]'), '');
    priceController.text = service.priceText.split(' ').first;
    _selectedCategoryId = service.categoryId;
  }

  void setCategory(int? id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();
    try {
      _categories = await _repository.getMainCategories();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // 🚀 دالة الإرسال (تقوم بالتعديل فقط PUT)
  Future<bool> updateService(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        _selectedCategoryId == null) {
      DialogHelper.showErrorDialog(context, 'يرجى تعبئة الحقول الأساسية');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _repository.updateService(
        serviceId: service.id,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.parse(priceController.text.trim()),
        categoryId: _selectedCategoryId!,
        imageFile: _imageFile,
      );

      _isLoading = false;
      notifyListeners();
      return true; // نجاح التعديل
    } on Failure catch (failure) {
      _isLoading = false;
      notifyListeners();
      debugPrint('❌ خطأ من السيرفر: ${failure.message}');
      DialogHelper.showErrorDialog(
        context,
        'البيانات المرسلة غير صحيحة ${failure.message}',
      );
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      // 🚀 سطر الطباعة 2 لمعرفة أخطاء الكود
      debugPrint('❌ خطأ برمجي في فلاتر: $e');
      DialogHelper.showErrorDialog(context, 'حدث خطأ أثناء التعديل');
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
