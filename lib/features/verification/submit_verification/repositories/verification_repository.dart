// مسار الملف: lib/features/verification/repositories/verification_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/error/api_error_handler.dart';

class VerificationRepository {
  final ApiService _apiService;

  VerificationRepository(this._apiService);

  // 🚀 إرسال طلب التوثيق (رفع الملف ورقم السند)
  Future<void> submitVerificationPackage({
    required int packageId,
    required String bondNumber,
    required File imageBond,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'verification_package_id': packageId.toString(),
        'number_bond': bondNumber,
        'bank_name': 'تحويل بنكي مباشر', // ✅ حقل إضافي لضمان عدم انهيار السيرفر إذا كان يتوقعه
        'image_bond': await MultipartFile.fromFile(
          imageBond.path,
          // ✅ تحسين استخراج اسم الملف لضمان التوافق التام مع السيرفر
          filename: imageBond.path.split(RegExp(r'[/\\]')).last,
        ),
      });

      final response = await _apiService.post(
        ApiEndpoints.userVerificationPackages,
        data: formData,
      );

      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // 🛡️ إرسال طلب توثيق جديد (بمحتوى نصي فقط)
  Future<void> sendVerificationRequest(String content) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.verificationRequests,
        data: {'content': content},
      );
      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}