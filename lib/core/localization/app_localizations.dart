// مسار الملف: lib/core/localization/app_localizations.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  // دالة مساعدة للوصول للكلاس من أي مكان
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  // قراءة ملف الـ JSON حسب اللغة المختارة
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  // دالة الترجمة التي تبحث عن الكلمة وتدعم استبدال المتغيرات
  String translate(String key, {Map<String, String>? args}) {
    String translation = _localizedStrings[key] ?? key;
    if (args != null) {
      args.forEach((placeholder, value) {
        translation = translation.replaceAll('{$placeholder}', value);
      });
    }
    return translation;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// ===================================================================
// 🚀 Extension احترافي لتسهيل الاستخدام في الواجهات
// ===================================================================
extension TranslateExtension on BuildContext {
  /// دالة لجلب النص المترجم بسهولة، تدعم المتغيرات أيضا: context.tr('key', args: {'id': '123'})
  String tr(String key, {Map<String, String>? args}) {
    return AppLocalizations.of(this)?.translate(key, args: args) ?? key;
  }
}