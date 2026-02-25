// مسار الملف: lib/core/storage/token_storage.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'hive_keys.dart';


/// هذا الكلاس يتخاطب مع Hive، وباقي التطبيق يتخاطب مع هذا الكلاس.

class TokenStorage {
  // 📥 دالة لجلب التوكن
  Future<String?> getToken() async {
    // نفتح الصندوق الخاص بالإعدادات ونجلب التوكن
    var box = Hive.box(HiveKeys.settingsBox);
    return box.get(HiveKeys.tokenKey);
  }

  // 📤 دالة لحفظ التوكن (سنستخدمها عند تسجيل الدخول بنجاح)
  Future<void> saveToken(String token) async {
    var box = Hive.box(HiveKeys.settingsBox);
    await box.put(HiveKeys.tokenKey, token);
  }

  // 🗑️ دالة لحذف التوكن (سنستخدمها عند تسجيل الخروج)
  Future<void> deleteToken() async {
    var box = Hive.box(HiveKeys.settingsBox);
    await box.delete(HiveKeys.tokenKey);
  }
}