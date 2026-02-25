import 'package:hive_flutter/hive_flutter.dart';
import 'hive_keys.dart';

class HiveHelper {
  //سنستدعيها أول شيء عند تشغيل التطبيق لتهيئة قاعدة البيانات
  static Future<void> init() async {
    await Hive.initFlutter();
    // تهيئة Hive للعمل مع فلاتر
    await Hive.openBox(HiveKeys.settingsBox);
    // فتح صندوق الإعدادات الأساسية ليكون جاهزاً للقراءة والكتابة
  }

  // دالة مساعدة لتنظيف البيانات عند تسجيل الخروج (سنستخدمها لاحقاً)
  static Future<void> clareAllData() async {
    await Hive.box(HiveKeys.settingsBox).clear();
    //يمكننا إضافة مسح صناديق أخرى
  }
}
