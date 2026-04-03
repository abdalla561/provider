// مسار الملف: lib/features/withdraw/repositories/withdraw_repository.dart

import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/core/network/api_endpoints.dart';
import 'package:service_provider_app/core/network/error/api_error_handler.dart';

class WithdrawRepository {
  final ApiService _apiService;

  WithdrawRepository(this._apiService);

  /// 📤 إرسال طلب سحب أرباح
  Future<void> submitWithdrawRequest(double amount) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.withdrawRequest,
        data: {'amount': amount},
      );
      
      ApiErrorHandler.handleResponse(response);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
