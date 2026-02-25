import "package:flutter/material.dart";
import 'package:hive/hive.dart';
// import '../../../core/storage/hive_helper.dart';
import '../../../core/storage/hive_keys.dart';

class SettingsProvider extends ChangeNotifier {
final Box _settingsBox = Hive.box(HiveKeys.settingsBox);

// المتغيرات التي تحمل الحالة الحالية
  late bool _isDarkMode;
  late String _languageCode;


//يقرأ البيانات المحفوظة بمجرد تشغيل التطبيق
  SettingsProvider() {
    // تحميل الإعدادات من Hive عند إنشاء المزود
    // إذا لم يكن هناك قيمة محفوظة للثيم، نستخدم false كافتراضي
    _isDarkMode = _settingsBox.get(HiveKeys.themeKey, defaultValue: false);

    //
    // إذا لم يكن هناك قيمة محفوظة للغة، نستخدم 'en' كافتراضي
    _languageCode = _settingsBox.get(HiveKeys.langKey, defaultValue: 'en');
  }

// getters للوصول إلى الحالة الحالية
  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  Locale get locale => Locale(_languageCode);

// دوال لتحديث الحالة وتخزينها في Hive

// الثيم
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _settingsBox.put(HiveKeys.themeKey, _isDarkMode);
    notifyListeners(); // لإعلام الواجهات التي تعتمد على هذا المزود بالتحديث
  }
//اللغه
  void changeLanguage(String newLangCode) {
    _languageCode = newLangCode;
    _settingsBox.put(HiveKeys.langKey, _languageCode);
    notifyListeners(); // لإعلام الواجهات التي تعتمد على هذا المزود بالتحديث
  }
  
}
