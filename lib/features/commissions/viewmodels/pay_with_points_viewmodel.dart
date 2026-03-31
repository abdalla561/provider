// مسار الملف: lib/features/commissions/viewmodels/pay_with_points_viewmodel.dart

import 'package:flutter/material.dart';
import '../repositories/commissions_repository.dart';

class PayWithPointsViewModel extends ChangeNotifier {
  // ignore: unused_field
  final CommissionsRepository _repository; // سيستخدم عند ربط مسار الـ API

  PayWithPointsViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> confirmPointsPayment(double amount, int pointsToDeduct) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: استدعاء دالة الدفع بالنقاط المؤكدة من الـ API
      // await _repository.confirmPointsPayment(amount, pointsToDeduct);
      
      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true; // الدفع ناجح
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'payment_failed';
      notifyListeners();
      return false; // الدفع فشل
    }
  }
}
