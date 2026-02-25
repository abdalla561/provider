// مسار الملف: lib/core/network/api_endpoints.dart

/// 📂 اسم الملف: api_endpoints.dart
/// 📝 الوصف: يحتوي على جميع الروابط (URLs) الخاصة بالـ API.

class ApiEndpoints {
  // ⛔ منع إنشاء كائن من هذا الكلاس
  ApiEndpoints._();

  // الرابط الأساسي للسيرفر (Base URL) - (قم بتغييره برابط السيرفر الخاص بك)
  static const String baseUrl = "https://your-api-domain.com/api/";

  // روابط الـ Endpoints (أمثلة سنستخدمها لاحقاً)
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String providerProfile = "provider/profile";
}
