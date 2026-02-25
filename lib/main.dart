// // مسار الملف: lib/main.dart
// import 'core/localization/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'core/storage/hive_helper.dart';
// import 'features/settings/viewmodels/settings_provider.dart';
// import 'core/theme/app_theme.dart';

// void main() async {
//   // التأكد من تهيئة بيئة فلاتر قبل تشغيل أي دوال غير متزامنة (async)
//   WidgetsFlutterBinding.ensureInitialized();

//   // تهيئة Hive وفتح الصناديق الأساسية
//   await HiveHelper.init();

//   // تغليف التطبيق بـ MultiProvider لكي نتمكن من إضافة Providers أخرى لاحقاً (مثل AuthProvider)
//   runApp(
//     MultiProvider(
//       providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // نستمع هنا للـ SettingsProvider لكي يتغير التطبيق بالكامل عند تغيير اللغة أو الثيم
//     final settingsProvider = Provider.of<SettingsProvider>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Provider App',

//       // إعدادات الثيم (سنقوم بتخصيصها لاحقاً بملف ألوانك الخاصة)
//       // 👇 التعديل هنا: نستخدم الثيم المخصص الخاص بك
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: settingsProvider.themeMode, // يتغير بناءً على الـ Provider
//       // إعدادات اللغة
//       locale: settingsProvider.locale, // اللغة الحالية
//       supportedLocales: const [
//         Locale('ar'), // العربية
//         Locale('en'), // الإنجليزية
//       ],
//       localizationsDelegates: const [
//         AppLocalizations.delegate, // المترجم الخاص بنا
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       // شاشة مؤقتة للتأكد من أن الكود يعمل
//       home: Scaffold(
//         appBar: AppBar(title: const Text('أساس المشروع جاهز')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 🌍 👇 التعديل هنا: استخدمنا context.tr() للترجمة التلقائية
//               Text(
//                 context.tr('welcome'),
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => settingsProvider.toggleDarkMode(),
//                 child: const Text('تغيير الوضع (Dark/Light)'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   final newLang = settingsProvider.languageCode == 'ar'
//                       ? 'en'
//                       : 'ar';
//                   settingsProvider.changeLanguage(newLang);
//                 },
//                 child: const Text('تغيير اللغة'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// مسار الملف: lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// 1. استدعاء ملفات التخزين والإعدادات
import 'core/storage/hive_helper.dart';
import 'features/settings/viewmodels/settings_provider.dart';

// 2. استدعاء ملفات الثيم والألوان الخاصة بك
import 'core/theme/app_theme.dart';
import 'core/theme/qs_color_extension.dart';

// 3. استدعاء ملف الترجمة الذي أنشأناه للتو
import 'core/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات المحلية
  await HiveHelper.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Provider App',

      // 🎨 ربط الثيم والألوان
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsProvider.themeMode,

      // 🌍 إعدادات اللغة الأساسية
      locale: settingsProvider.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],

      // 🌍 👇 التعديل هنا: أضفنا AppLocalizations.delegate لكي يقرأ التطبيق ملفات json
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('تجربة التأسيس'),
        backgroundColor: context.qsColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌍 👇 التعديل هنا: استخدمنا context.tr() للترجمة التلقائية
            Text(
              context.tr('welcome'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),

            Text(
              'هذا النص يستخدم الألوان المخصصة',
              style: TextStyle(color: context.qsColors.textSub, fontSize: 16),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => settingsProvider.toggleDarkMode(),
              // 🌍 👇 التعديل هنا
              child: Text(context.tr('change_theme')),
            ),
            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                final newLang = settingsProvider.languageCode == 'ar'
                    ? 'en'
                    : 'ar';
                settingsProvider.changeLanguage(newLang);
              },
              // 🌍 👇 التعديل هنا
              child: Text(context.tr('change_language')),
            ),
          ],
        ),
      ),
    );
  }
}
