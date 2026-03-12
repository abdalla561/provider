// مسار الملف: lib/features/orders/viewmodels/orders_viewmodel.dart

import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrdersViewModel extends ChangeNotifier {
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  final List<String> tabs = ['all', 'new_order', 'in_progress', 'completed'];

  // بيانات وهمية مطابقة للصورة تماماً
  final List<OrderModel> _allOrders = [
    OrderModel(
      id: '1',
      customerName: 'أحمد محمد',
      serviceName: 'صيانة تكييف',
      customerImage: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200&auto=format&fit=crop', // صورة رجل
      isVerified: true,
      price: 150.0,
      location: 'الرياض، حي الملز، شارع الستين',
      description: 'المكيف يخرج هواء حار ويحتاج تنظيف فلاتر وتعبئة فريون.',
      timeAgo: 'منذ ساعتين',
      status: OrderStatus.newOrder,
    ),
    OrderModel(
      id: '2',
      customerName: 'سارة علي',
      serviceName: 'نظافة عامة',
      customerImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop', // صورة فتاة
      isVerified: false,
      price: 200.0,
      location: 'الرياض، حي النخيل',
      timeAgo: 'أمس',
      status: OrderStatus.inProgress,
    ),
    OrderModel(
      id: '3',
      customerName: 'عميل زائر',
      serviceName: 'سباكة',
      customerImage: '', // بدون صورة (سيعرض أيقونة افتراضية)
      isVerified: false,
      price: 60.0,
      oldPrice: 80.0, // سعر مشطوب
      location: 'الدمام، حي الشاطئ',
      timeAgo: 'منذ 5 ساعات',
      status: OrderStatus.newOrder,
    ),
  ];

  List<OrderModel> get filteredOrders {
    if (_selectedTabIndex == 0) return _allOrders; // الكل
    if (_selectedTabIndex == 1) return _allOrders.where((o) => o.status == OrderStatus.newOrder).toList(); // جديد
    if (_selectedTabIndex == 2) return _allOrders.where((o) => o.status == OrderStatus.inProgress).toList(); // قيد التنفيذ
    return _allOrders.where((o) => o.status == OrderStatus.completed).toList(); // مكتمل
  }

  void changeTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }
}