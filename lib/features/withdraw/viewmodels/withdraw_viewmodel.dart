// مسار الملف: lib/features/withdraw/viewmodels/withdraw_viewmodel.dart

import 'package:flutter/material.dart';
import '../repositories/withdraw_repository.dart';

class WithdrawViewModel extends ChangeNotifier {
  final WithdrawRepository _repository;

  WithdrawViewModel(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// 🚀 التحقق من الرصيد والتقديم
  Future<bool> validateAndSubmit({
    required double amount,
    required int availablePoints,
  }) async {
    // 1. التحقق من أن الرصيد كافٍ
    if (amount > availablePoints) {
      _errorMessage = 'insufficient_balance';
      notifyListeners();
      return false;
    }

    if (amount <= 0) {
      _errorMessage = 'error_invalid_amount';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.submitWithdrawRequest(amount);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
