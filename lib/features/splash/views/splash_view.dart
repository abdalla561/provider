import 'package:flutter/material.dart';
import 'package:service_provider_app/core/widgets/app_logo.dart';
import 'package:service_provider_app/features/auth/views/welcome_view.dart';

// 👇 الاستدعاءات الجديدة الخاصة بالتخزين والشاشة الرئيسية
import 'package:service_provider_app/core/storage/token_storage.dart';
import 'package:service_provider_app/features/home/views/main_view.dart'; // إذا كان اسم شاشتك الرئيسية مختلفاً (مثل MainView) قم بتعديله هنا

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // إعداد الأنيميشن (تكبير وظهور تدريجي)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    // تشغيل دالة الفحص والانتقال الذكية
    _checkAuthAndNavigate();
  }

  // 🛡️ دالة التحقق من تسجيل الدخول (Auth Guard)
  Future<void> _checkAuthAndNavigate() async {
    // 1. ننتظر 3 ثوانٍ ليكتمل الأنيميشن
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // 2. نجلب التوكن من Hive للتأكد مما إذا كان المستخدم مسجلاً من قبل
    final tokenStorage = TokenStorage();
    final String? token = await tokenStorage.getToken();

    // 3. الشرط الذكي: هل يوجد توكن؟
    if (token != null && token.isNotEmpty) {
      // ✅ المستخدم لديه حساب ومسجل دخول -> نوجهه للرئيسية
      // ✅ نوجهه لـ MainView (التي تحتوي على شريط التنقل) وليس HomeDashboardView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainView()),
      );
      ;
    } else {
      // ❌ المستخدم غير مسجل -> نوجهه لشاشة الترحيب/التسجيل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const AppLogo(size: 120),
          ),
        ),
      ),
    );
  }
}
