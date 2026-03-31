// مسار الملف: lib/features/home/views/main_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/features/commissions/views/commissions_view.dart';
import 'package:service_provider_app/features/home/views/home_dashboard_view.dart';
import 'package:service_provider_app/features/orders/Views/orders_view.dart';
import 'package:service_provider_app/features/profile/views/profile_view.dart';
import 'package:service_provider_app/features/services/views/manage_services_view.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../viewmodels/main_viewmodel.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: const _MainViewBody(),
    );
  }
}

class _MainViewBody extends StatelessWidget {
  const _MainViewBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context);

    // قائمة الشاشات (حالياً الرئيسية فقط، والباقي شاشات فارغة مؤقتاً)
    final List<Widget> screens = [
      const HomeDashboardView(),
      const OrdersView(),
      const ManageServicesView(),
      const CommissionsView(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: context.qsColors.background,
      body: screens[viewModel.currentIndex],

      // شريط التنقل السفلي
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTap: viewModel.changeTab,
          backgroundColor: Theme.of(context).cardColor,
          type: BottomNavigationBarType.fixed, // مهم لكي لا تختفي النصوص
          selectedItemColor: context.qsColors.primary,
          unselectedItemColor: context.qsColors.textSub.withOpacity(0.5),
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_filled),
              label: context.tr('nav_home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              label: context.tr('nav_orders'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.category_outlined),
              label: context.tr('nav_services'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              label: context.tr('nav_commissions'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: context.tr('nav_profile'),
            ),
          ],
        ),
      ),
    );
  }
}
