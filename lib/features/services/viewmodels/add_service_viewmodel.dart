// // مسار الملف: lib/features/services/viewmodels/add_service_viewmodel.dart

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:service_provider_app/core/network/error/failure.dart';
// import 'package:service_provider_app/core/utils/dialog_helper.dart';
// import 'package:service_provider_app/features/services/models/service_details_model.dart';

// // الاستدعاءات الخاصة بالـ Repository والـ Model
// import '../repositories/manage_services_repository.dart';
// import '../models/category_model.dart'; // ✅ تم إضافة استدعاء المودل هنا

// class AddServiceViewModel extends ChangeNotifier {
//   final ManageServicesRepository _repository;
//   final ServiceDetailsModel? serviceToEdit;

//   // ✅ دالة البناء الصحيحة والمدمجة (واحدة فقط)
//   AddServiceViewModel(this._repository, {this.serviceToEdit}) {
//     fetchCategories(); // جلب الفئات تلقائياً عند فتح الشاشة
//   }

//   // =====================================
//   // 1. المتحكمات (Controllers)
//   // =====================================
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();

//   // =====================================
//   // 2. إدارة الفئات (Categories)
//   // =====================================
//   int? _selectedCategoryId;
//   int? get selectedCategoryId => _selectedCategoryId;

//   List<CategoryModel> _categories = [];
//   List<CategoryModel> get categories => _categories;

//   bool _isLoadingCategories = false;
//   bool get isLoadingCategories => _isLoadingCategories;

//   void setCategory(int? id) {
//     _selectedCategoryId = id;
//     notifyListeners();
//   }

//   // Future<void> fetchCategories() async {
//   //   _isLoadingCategories = true;
//   //   notifyListeners();

//   //   try {
//   //     _categories = await _repository.getMainCategories();
//   //   } catch (e) {
//   //     // في حال حدوث خطأ، ستظل القائمة فارغة
//   //     debugPrint('Error fetching categories: $e');
//   //   } finally {
//   //     _isLoadingCategories = false;
//   //     notifyListeners();
//   //   }
//   // }






  
//   // دالة جلب الفئات
//   Future<void> fetchCategories() async {
//     _isLoadingCategories = true;
//     notifyListeners();

//     try {
//       _categories = await _repository.getMainCategories();
//       debugPrint('✅ تم جلب الفئات بنجاح: عددها ${_categories.length}');
//     } catch (e) {
//       // 🚨 الآن سنطبع الخطأ لكي نعرف المشكلة من السيرفر!
//       debugPrint('❌ حدث خطأ أثناء جلب الفئات: $e');
//     } finally {
//       _isLoadingCategories = false;
//       notifyListeners();
//     }
//   }

//   // =====================================
//   // 3. إدارة الصورة (Image)
//   // =====================================
//   File? _imageFile;
//   File? get imageFile => _imageFile;

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _imageFile = File(pickedFile.path);
//       notifyListeners();
//     }
//   }

//   // =====================================
//   // 4. إرسال البيانات (Submit)
//   // =====================================
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<bool> submitService(BuildContext context) async {
//     if (nameController.text.trim().isEmpty ||
//         priceController.text.trim().isEmpty ||
//         _selectedCategoryId == null) {
//       // _showError(context, 'يرجى تعبئة الحقول الأساسية (الاسم، الفئة، السعر)');
//       DialogHelper.showErrorDialog(
//         context,
//         'يرجى تعبئة الحقول الأساسية (الاسم، الفئة، السعر)',
//       );
//       return false;
//     }

//     _isLoading = true;
//     notifyListeners();

//     try {
//       await _repository.createService(
//         name: nameController.text.trim(),
//         description: descriptionController.text.trim(),
//         price: double.parse(priceController.text.trim()),
//         categoryId: _selectedCategoryId!,
//         imageFile: _imageFile,
//       );

//       _isLoading = false;
//       notifyListeners();
//       return true; // نجاح الرفع
//     } on Failure catch (failure) {
//       _isLoading = false;
//       notifyListeners();
//       // _showError(context, failure.message);
//       DialogHelper.showErrorDialog(context, failure.message);
//       return false;
//     } catch (e) {
//       _isLoading = false;
//       notifyListeners();
//       // _showError(context, 'حدث خطأ غير متوقع');
//       DialogHelper.showErrorDialog(context, 'حدث خطأ غير متوقع');
//       return false;
//     }
//   }

//   // =====================================
//   // 5. دوال مساعدة (Helpers)
//   // =====================================
//   // void _showError(BuildContext context, String msg) {
//   //   ScaffoldMessenger.of(context).showSnackBar(
//   //     SnackBar(
//   //       content: Text(msg, style: const TextStyle(fontFamily: 'Cairo')),
//   //       backgroundColor: Colors.red.shade700,
//   //       behavior: SnackBarBehavior.floating,
//   //     )
//   //   );
//   // }

//   @override
//   void dispose() {
//     nameController.dispose();
//     priceController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }


  
// }


// مسار الملف: lib/features/services/viewmodels/add_service_viewmodel.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_app/core/network/error/failure.dart';
import 'package:service_provider_app/core/utils/dialog_helper.dart';
import 'package:service_provider_app/features/services/models/service_details_model.dart';

// الاستدعاءات الخاصة بالـ Repository والـ Model
import '../repositories/manage_services_repository.dart';
import '../models/category_model.dart'; // ✅ تم إضافة استدعاء المودل هنا

class AddServiceViewModel extends ChangeNotifier {
  final ManageServicesRepository _repository;
  final ServiceDetailsModel? serviceToEdit;

  // ✅ دالة البناء الصحيحة والمدمجة (واحدة فقط)
  AddServiceViewModel(this._repository, {this.serviceToEdit}) {
    fetchCategories().then((_) {
      _initEditData();
    });
  }

  // =====================================
  // 1. المتحكمات (Controllers)
  // =====================================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController partialPercentController = TextEditingController();

  // =====================================
  // 2. إدارة الفئات (Categories)
  // =====================================
  int? _selectedCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  bool _isLoadingCategories = false;
  bool get isLoadingCategories => _isLoadingCategories;

  void setCategory(int? id) {
    _selectedCategoryId = id;
    notifyListeners();
  }

  void _initEditData() {
    if (serviceToEdit != null) {
      nameController.text = serviceToEdit!.title;
      descriptionController.text = serviceToEdit!.description;
      priceController.text = serviceToEdit!.priceText.replaceAll(RegExp(r'[^0-9.]'), '');
      // If serviceToEdit has a property for partialPercent, we'd use it here.
      // But we'll leave it empty or default it if not available.
      setCategory(serviceToEdit!.categoryId);
    }
  }

  // دالة جلب الفئات
  Future<void> fetchCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      _categories = await _repository.getMainCategories();
      debugPrint('✅ تم جلب الفئات بنجاح: عددها ${_categories.length}');
    } catch (e) {
      // 🚨 الآن سنطبع الخطأ لكي نعرف المشكلة من السيرفر!
      debugPrint('❌ حدث خطأ أثناء جلب الفئات: $e');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // =====================================
  // 3. إدارة الصورة (Image)
  // =====================================
  File? _imageFile;
  File? get imageFile => _imageFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // =====================================
  // 4. إرسال البيانات (Submit)
  // =====================================
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> submitService(BuildContext context) async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        partialPercentController.text.trim().isEmpty ||
        _selectedCategoryId == null) {
      DialogHelper.showErrorDialog(
        context,
        'يرجى تعبئة الحقول الأساسية (الاسم، الفئة، السعر، نسبة الدفع المسبق)',
      );
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (serviceToEdit == null) {
        await _repository.createService(
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          price: double.parse(priceController.text.trim()),
          categoryId: _selectedCategoryId!,
          requiredPartialPercent: int.parse(partialPercentController.text.trim()),
          imageFile: _imageFile,
        );
      } else {
        await _repository.updateService(
          serviceId: serviceToEdit!.id,
          name: nameController.text.trim(),
          description: descriptionController.text.trim(),
          price: double.parse(priceController.text.trim()),
          categoryId: _selectedCategoryId!,
          requiredPartialPercent: int.parse(partialPercentController.text.trim()),
          imageFile: _imageFile,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true; // نجاح الرفع
    } on Failure catch (failure) {
      _isLoading = false;
      notifyListeners();
      DialogHelper.showErrorDialog(context, failure.message);
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      DialogHelper.showErrorDialog(context, 'حدث خطأ غير متوقع');
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    partialPercentController.dispose();
    super.dispose();
  }
}