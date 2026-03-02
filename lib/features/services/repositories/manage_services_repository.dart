// مسار الملف: lib/features/services/repositories/manage_services_repository.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/core/network/api_endpoints.dart';
import 'package:service_provider_app/core/network/error/api_error_handler.dart';
import 'package:service_provider_app/features/services/models/category_model.dart';
import '../../../core/storage/hive_keys.dart';
import '../models/manage_services_model.dart';
// أضف هذا الاستيراد في أعلى الملف لرفع الملفات
import 'package:dio/dio.dart';
import 'dart:io';

class ManageServicesRepository {
  final ApiService _apiService;
  final String _cacheKey = 'cached_manage_services';

  ManageServicesRepository(this._apiService);

  Future<List<ServiceModel>> getServices() async {
    var box = Hive.box(HiveKeys.settingsBox);

    try {
      // 1. جلب البيانات من الـ API (استبدل 'provider/services' بالرابط الفعلي لديك)
      final response = await _apiService.get(ApiEndpoints.myServices);
      final data = ApiErrorHandler.handleResponse(response);

      // 2. تحويل البيانات وتخزينها في Hive لتعمل بدون إنترنت
      final List responseList = data['data'] ?? data;
      await box.put(_cacheKey, responseList);

      // 3. إرجاع المودل
      return responseList.map((e) => ServiceModel.fromJson(e)).toList();
    } catch (e) {
      // 4. في حال فشل السيرفر أو انقطاع النت، نجلب من Hive
      final cachedData = box.get(_cacheKey);

      if (cachedData != null) {
        final List mapData = List.from(cachedData);
        return mapData
            .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }

      throw ApiErrorHandler.handle(e);
    }
  }

  // 🚀 دالة إضافة خدمة جديدة (POST /services)
  Future<void> createService({
    required String name,
    required String description,
    required double price,
    required int categoryId,
    File? imageFile,
  }) async {
    try {
      // تجهيز البيانات كـ FormData لرفع الصورة مع النصوص
      FormData formData = FormData.fromMap({
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "status": "available", // قيمة افتراضية حسب وثيقة الباك اند
        "is_available": 1,
        "is_active": 1,
        "distance_based_price": 0,
      });

      // إضافة الصورة إذا قام المستخدم باختيارها
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            "image_path", // نفس الاسم المطلوب في الوثيقة
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }

      // إرسال الطلب (التوكن يتم إرفاقه تلقائياً)
      final response = await _apiService.post(
        ApiEndpoints.myServices,
        data: formData,
      );
      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // مفتاح تخزين الفئات
  final String _categoriesCacheKey = 'cached_main_categories';

  // 🚀 دالة جلب الفئات الرئيسية (GET /categories/main)
  Future<List<CategoryModel>> getMainCategories() async {
    var box = Hive.box(HiveKeys.settingsBox);

    try {
      final response = await _apiService.get(ApiEndpoints.mainCategories);
      final data = ApiErrorHandler.handleResponse(response);

      // final List responseList = data['data'] ?? data;
      final List responseList = data['categories'] ?? data['data'] ?? [];
      // تخزينها في Hive
      await box.put(_categoriesCacheKey, responseList);

      return responseList.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      // قراءة من Hive في حال عدم وجود إنترنت
      final cachedData = box.get(_categoriesCacheKey);
      if (cachedData != null) {
        final List mapData = List.from(cachedData);
        return mapData
            .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
      throw ApiErrorHandler.handle(e);
    }
  }
}
