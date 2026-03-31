// مسار الملف: lib/features/commissions/repositories/commissions_repository.dart

import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/core/network/api_endpoints.dart';
import 'package:service_provider_app/core/network/error/api_error_handler.dart';
import 'package:service_provider_app/core/storage/hive_keys.dart';
import '../models/commission_model.dart';

class CommissionsRepository {
  final ApiService _apiService;
  final String _cacheKey = 'cached_commissions_data';

  CommissionsRepository(this._apiService);

  Future<CommissionDataModel> getCommissionsData() async {
    var box = Hive.box(HiveKeys.settingsBox);

    try {
      // محاولة جلب البيانات من الـ API الحقيقي
      final response = await _apiService.get(ApiEndpoints.commissions);
      final data = ApiErrorHandler.handleResponse(response);

      // التأكد من استخراج البيانات الصحيحة سواء كانت بالخارج أو داخل مفتاح 'data'
      final Map<String, dynamic> responseData = data['data'] ?? data;

      // تخزين البيانات للعمل بدون انترنت
      await box.put(_cacheKey, responseData);

      // تحويلها للنموذج
      return CommissionDataModel.fromJson(responseData);
    } catch (e) {
      // إذا فشل الاتصال، نجلب من الكاش (Hive)
      final cachedData = box.get(_cacheKey);

      if (cachedData != null) {
        final Map<String, dynamic> mapData =
            Map<String, dynamic>.from(cachedData);
        return CommissionDataModel.fromJson(mapData);
      }

      // إذا لم يكن هناك كاش، نرمي الخطأ ليعالجه الـ ViewModel
      throw ApiErrorHandler.handle(e);
    }
  }

  // دالة السداد باستخدام نقاط المكافآت
  Future<void> payWithPoints(double amount) async {
    try {
      // محاكاة الاتصال بالخادم
      // final response = await _apiService.post(
      //   ApiEndpoints.payWithPoints,
      //   data: {'amount': amount},
      // );
      // ApiErrorHandler.handleResponse(response);

      await Future.delayed(const Duration(seconds: 2)); // محاكاة عملية معالجة
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // دالة السداد بإرفاق السند
  Future<void> payWithReceipt({
    required String requestId,
    required String bondNumber,
    required String imagePath,
    String? description,
  }) async {
    try {
      final formData = FormData.fromMap({
        'request_id': requestId,
        'bond_number': bondNumber,
        'description': description ?? '',
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });

      final response = await _apiService.post(
        ApiEndpoints.requestCommissionBonds,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
