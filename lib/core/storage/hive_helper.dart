import 'package:hive_flutter/hive_flutter.dart';
import 'hive_keys.dart';

class HiveHelper {
  //سنستدعيها أول شيء عند تشغيل التطبيق لتهيئة قاعدة البيانات
  static Future<void> init() async {
    await Hive.initFlutter();
    // تهيئة Hive للعمل مع فلاتر
    await Hive.openBox(HiveKeys.settingsBox);
    await Hive.openBox(HiveKeys.worksBox); // 💼 فتح صندوق الأعمال
    await Hive.openBox(HiveKeys.servicesBox); // 🛠️ فتح صندوق الخدمات
    await Hive.openBox(HiveKeys.phonesBox); // 📞 صندوق الهواتف
    await Hive.openBox(HiveKeys.banksBox); // 🏦 صندوق البنوك
  }

  // دالة مساعدة لتنظيف البيانات عند تسجيل الخروج (سنستخدمها لاحقاً)
  static Future<void> clareAllData() async {
    await Hive.box(HiveKeys.settingsBox).clear();
    await Hive.box(HiveKeys.worksBox).clear();
    await Hive.box(HiveKeys.servicesBox).clear();
    await Hive.box(HiveKeys.phonesBox).clear();
    await Hive.box(HiveKeys.banksBox).clear();
  }
}
