// // مسار الملف: lib/features/packages/repositories/packages_repository.dart

// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:hive/hive.dart';
// import 'package:service_provider_app/core/network/api_client.dart';
// import 'package:service_provider_app/core/storage/hive_keys.dart';

// import '../../../../core/network/api_endpoints.dart'; // تأكد أن الروابط مضافة هنا
// import '../../../../core/network/error/api_error_handler.dart';
// import '../models/package_model.dart';

// class PackagesRepository {
//   final ApiService _apiService;

//   PackagesRepository(this._apiService);

//   // 📥 1. جلب الباقات من السيرفر
//   // Future<List<PackageModel>> getPackages() async {
//   //   try {
//   //     final response = await _apiService.get(ApiEndpoints.availablePointsPackages);
//   //     final data = ApiErrorHandler.handleResponse(response);

//   //     final List responseList = data['data'] ?? data ?? [];

//   //     // نمرر الـ entry.value (البيانات) والـ entry.key (الرقم التسلسلي index)
//   //     return responseList.asMap().entries.map((entry) {
//   //       return PackageModel.fromJson(entry.value, entry.key);
//   //     }).toList();
//   //   } catch (e) {
//   //     throw ApiErrorHandler.handle(e);
//   //   }
//   // }
//   // 📥 1. جلب الباقات (API + Hive)
//   Future<List<PackageModel>> getPackages() async {
//     var box = Hive.box(HiveKeys.settingsBox); // نفتح صندوق التخزين

//     try {
//       final response = await _apiService.get(ApiEndpoints.availablePointsPackages);

//       // هنا البيانات الخام القادمة من السيرفر
//       final data = ApiErrorHandler.handleResponse(response);

//       // 🚀 التعديل الجوهري هنا: فحص نوع البيانات بذكاء
//       List responseList = [];
//       if (data is List) {
//         // إذا كان السيرفر يرسل مصفوفة مباشرة [...] مثل حالتك الآن
//         responseList = data;
//       } else if (data is Map && data.containsKey('data')) {
//         // إذا كان السيرفر يرسلها داخل كائن {"data": [...]}
//         responseList = data['data'];
//       }

//       // حفظ البيانات في Hive لتكون متاحة (أوفلاين)
//       await box.put(_cacheKey, responseList);

//       // تحويل البيانات إلى مودل
//       return responseList.asMap().entries.map((entry) {
//         return PackageModel.fromJson(entry.value, entry.key);
//       }).toList();

//     } catch (e) {
//       // في حال انقطاع الإنترنت أو فشل السيرفر، نبحث في Hive
//       final cachedData = box.get(_cacheKey);

//       if (cachedData != null) {
//         print('🌐 لا يوجد إنترنت.. تم جلب الباقات من التخزين المحلي (Hive)');
//         final List mapData = List.from(cachedData);
//         return mapData.asMap().entries.map((entry) {
//           return PackageModel.fromJson(Map<String, dynamic>.from(entry.value), entry.key);
//         }).toList();
//       }

//       throw ApiErrorHandler.handle(e);
//     }
//   }

//   // 🚀 2. شراء باقة عبر رفع سند
//   Future<void> subscribeToPackage({
//     required int packageId,
//     required String bondNumber,
//     required String bankName,
//     required File bondImage,
//   }) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'package_id': packageId,
//         'bond_number': bondNumber,
//         'bank_name': bankName,
//         'bond_image': await MultipartFile.fromFile(
//           bondImage.path,
//           filename: bondImage.path.split('/').last,
//         ),
//       });

//       final response = await _apiService.post(
//         ApiEndpoints.subscribePointsPackage,
//         data: formData,
//       );

//       ApiErrorHandler.handleResponse(response);
//     } catch (e) {
//       throw ApiErrorHandler.handle(e);
//     }
//   }

//   // 💸 3. دالة سحب الأرباح (Withdraw) التي ذكرتها
//   Future<void> withdrawRequest(double amount) async {
//     try {
//       final response = await _apiService.post(
//         ApiEndpoints.withdrawRequest,
//         data: {"amount": amount},
//       );
//       ApiErrorHandler.handleResponse(response);
//     } catch (e) {
//       throw ApiErrorHandler.handle(e);
//     }
//   }
// }

// مسار الملف: lib/features/packages/repositories/packages_repository.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:service_provider_app/core/network/api_client.dart'; // تأكد أن هذا يحمل كلاس ApiService
import 'package:service_provider_app/core/storage/hive_keys.dart';

import '../../../../core/network/api_endpoints.dart'; // تأكد أن الروابط مضافة هنا
import '../../../../core/network/error/api_error_handler.dart';
import '../models/package_model.dart';

class PackagesRepository {
  final ApiService _apiService;

  // 🚀 التعديل هنا: قمنا بتعريف مفتاح التخزين الذي كان مفقوداً ويسبب الخطأ
  final String _cacheKey = 'cached_points_packages';

  PackagesRepository(this._apiService);

  // 📥 1. جلب الباقات من السيرفر
  // Future<List<PackageModel>> getPackages() async {
  //   try {
  //     final response = await _apiService.get(ApiEndpoints.availablePointsPackages);
  //     final data = ApiErrorHandler.handleResponse(response);

  //     final List responseList = data['data'] ?? data ?? [];

  //     // نمرر الـ entry.value (البيانات) والـ entry.key (الرقم التسلسلي index)
  //     return responseList.asMap().entries.map((entry) {
  //       return PackageModel.fromJson(entry.value, entry.key);
  //     }).toList();
  //   } catch (e) {
  //     throw ApiErrorHandler.handle(e);
  //   }
  // }

  // 📥 1. جلب الباقات (API + Hive)
  Future<List<PackageModel>> getPackages() async {
    var box = Hive.box(HiveKeys.settingsBox); // نفتح صندوق التخزين

    try {
      final response = await _apiService.get(
        ApiEndpoints.availablePointsPackages,
      );

      // هنا البيانات الخام القادمة من السيرفر
      final data = ApiErrorHandler.handleResponse(response);

      // 🚀 التعديل الجوهري هنا: فحص نوع البيانات بذكاء
      List responseList = [];
      if (data is List) {
        // إذا كان السيرفر يرسل مصفوفة مباشرة [...] مثل حالتك الآن
        responseList = data;
      } else if (data is Map && data.containsKey('data')) {
        // إذا كان السيرفر يرسلها داخل كائن {"data": [...]}
        responseList = data['data'];
      }

      // حفظ البيانات في Hive لتكون متاحة (أوفلاين)
      await box.put(_cacheKey, responseList);

      // تحويل البيانات إلى مودل
      return responseList.asMap().entries.map((entry) {
        return PackageModel.fromJson(entry.value, entry.key);
      }).toList();
    } catch (e) {
      // في حال انقطاع الإنترنت أو فشل السيرفر، نبحث في Hive
      final cachedData = box.get(_cacheKey);

      if (cachedData != null) {
        print('🌐 لا يوجد إنترنت.. تم جلب الباقات من التخزين المحلي (Hive)');
        final List mapData = List.from(cachedData);
        return mapData.asMap().entries.map((entry) {
          return PackageModel.fromJson(
            Map<String, dynamic>.from(entry.value),
            entry.key,
          );
        }).toList();
      }

      throw ApiErrorHandler.handle(e);
    }
  }

  // 🚀 2. شراء باقة عبر رفع سند
  Future<void> subscribeToPackage({
    required int packageId,
    required String bondNumber,
    required String bankName,
    required File bondImage,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'package_id': packageId,
        'bond_number': bondNumber,
        'bank_name': bankName,
        'bond_image': await MultipartFile.fromFile(
          bondImage.path,
          filename: bondImage.path.split('/').last,
        ),
      });

      final response = await _apiService.post(
        ApiEndpoints.subscribePointsPackage,
        data: formData,
      );

      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  // 💸 3. دالة سحب الأرباح (Withdraw) التي ذكرتها
  Future<void> withdrawRequest(double amount) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.withdrawRequest,
        data: {"amount": amount},
      );
      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
