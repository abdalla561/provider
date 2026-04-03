// مسار الملف: lib/features/commissions/viewmodels/commissions_stats_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:service_provider_app/features/points/repositories/points_repository.dart';
import 'package:service_provider_app/features/profile/repositories/profile_repository.dart';
import 'package:service_provider_app/core/network/error/failure.dart';
import '../models/provider_commission_summary_model.dart';
import '../../points/models/points_balance_model.dart';
import '../repositories/commissions_repository.dart';

class CommissionsStatsViewModel extends ChangeNotifier {
  final CommissionsRepository _repository;
  final PointsRepository _pointsRepository;
  final ProfileRepository _profileRepository;

  CommissionsStatsViewModel(
    this._repository,
    this._pointsRepository,
    this._profileRepository,
  ) {
    // جلب البيانات فوراً عند بدء الـ ViewModel
    fetchStatsData();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProviderCommissionSummaryModel? _statsSummary;
  ProviderCommissionSummaryModel? get statsSummary => _statsSummary;

  PointsBalanceModel? _pointsBalance;
  PointsBalanceModel? get pointsBalance => _pointsBalance;

  int _verificationDaysLeft = 0;
  int get verificationDaysLeft => _verificationDaysLeft;

  bool _isVerified = false;
  bool get isVerified => _isVerified;

  Future<void> fetchStatsData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 🚀 جلب البيانات الثلاثة (ملخص العمولة، رصيد النقاط، والبروفايل) بشكل متزامن
      final results = await Future.wait([
        _repository.getProviderCommissionSummary(),
        _pointsRepository.getPointsBalance(),
        _profileRepository.getMyProfile(),
      ]);

      _statsSummary = results[0] as ProviderCommissionSummaryModel;
      _pointsBalance = results[1] as PointsBalanceModel;
      
      final profile = results[2] as dynamic; 
      _isVerified = profile.verificationProvider ?? false;
      _calculateVerificationDays(profile.providerVerifiedUntil);

      _isLoading = false;
      notifyListeners();
    } on Failure catch (failure) {
      _isLoading = false;
      _errorMessage = failure.message;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'error_unexpected_fetch_data';
      notifyListeners();
    }
  }

  void _calculateVerificationDays(DateTime? verifiedUntil) {
    if (verifiedUntil == null) {
      _verificationDaysLeft = 0;
      return;
    }
    final now = DateTime.now();
    final difference = verifiedUntil.difference(now).inDays;
    _verificationDaysLeft = difference > 0 ? difference : 0;
  }
}
