// مسار الملف: lib/features/verification/repositories/verification_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:service_provider_app/core/network/api_client.dart';
// import '../../../../core/network/api_service.dart';
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
        'verification_package_id': packageId,
        'number_bond': bondNumber,
        'image_bond': await MultipartFile.fromFile(
          imageBond.path,
          filename: imageBond.path.split('/').last,
        ),
      });

      final response = await _apiService.post(
        ApiEndpoints.userVerificationPackages, // تأكد من إضافته في ملف الروابط
        data: formData,
      );

      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}