import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/features/services/repositories/manage_services_repository.dart';
import 'package:service_provider_app/features/services/viewmodels/manage_services_viewmodel.dart';
import 'package:service_provider_app/features/commissions/repositories/commissions_repository.dart';
import 'package:service_provider_app/features/commissions/viewmodels/commissions_viewmodel.dart';
import 'package:service_provider_app/features/commissions/viewmodels/pay_commissions_viewmodel.dart';
import 'package:service_provider_app/features/commissions/viewmodels/pay_with_points_viewmodel.dart';
import 'package:service_provider_app/features/profile/repositories/profile_repository.dart';
import 'package:service_provider_app/features/profile/viewmodels/profile_viewmodel.dart';
// 1. استدعاء ملفات الشبكة والتخزين (التي نسيناها) 🌐
import 'core/storage/token_storage.dart';
import 'features/home/repositories/home_repository.dart';

// 2. استدعاء الـ ViewModels 🧠
import 'features/settings/viewmodels/settings_provider.dart';
import 'features/home/viewmodels/main_viewmodel.dart';

// 3. استدعاء الثيم، الترجمة، وشاشة البداية 🎨
import 'core/storage/hive_helper.dart';
import 'core/theme/app_theme.dart';
// import 'core/theme/qs_color_extension.dart'; // إذا كنت تستخدمها في main
import 'core/localization/app_localizations.dart';
import 'features/splash/views/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة قاعدة البيانات المحلية
  await HiveHelper.init();

  // ========================================================
  // 🚀 👇 التعديل الجوهري هنا: تجهيز الاعتماديات (API & Repository)
  // ========================================================
  final tokenStorage = TokenStorage();
  final apiService = ApiService(tokenStorage);
  final homeRepository = HomeRepository(apiService);
  final manageServicesRepository = ManageServicesRepository(apiService);
  final commissionsRepository = CommissionsRepository(apiService);
  final profileRepository = ProfileRepository(apiService);

  runApp(
    MultiProvider(
      providers: [
        // 💉 حقن الخدمات الأساسية لتكون متاحة عبر context
        Provider<TokenStorage>.value(value: tokenStorage),
        Provider<ApiService>.value(value: apiService),

        // ⚙️ 👇 التعديل هنا: أضفنا SettingsProvider لكي لا يتعطل التطبيق!
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // 📱 ViewModel الخاص بشريط التنقل السفلي
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        
        // 🏠 ViewModel الخاص بالشاشة الرئيسية (مررنا له الـ Repository)
        ChangeNotifierProvider(create: (_) => HomeViewModel(homeRepository)),

        //لادارة الخدمات
        ChangeNotifierProvider(create: (_) => ManageServicesViewModel(manageServicesRepository)),

        // العمولات
        ChangeNotifierProvider(create: (_) => CommissionsViewModel(commissionsRepository)),
        ChangeNotifierProvider(create: (_) => PayCommissionsViewModel(commissionsRepository)),
        ChangeNotifierProvider(create: (_) => PayWithPointsViewModel(commissionsRepository)),

        // 🔥 الملف الشخصي
        ChangeNotifierProvider(create: (_) => ProfileViewModel(profileRepository)),
      ],
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

      // 🌍 إعدادات الترجمة
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const SplashView(),
    );
  }
}