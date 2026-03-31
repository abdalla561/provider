// مسار الملف: lib/features/profile/repositories/profile_repository.dart

import 'package:service_provider_app/core/network/api_client.dart';

// import '../../../../core/network/api_service.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/error/api_error_handler.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final ApiService _apiService;

  ProfileRepository(this._apiService);

  Future<ProfileModel> getMyProfile() async {
    try {
      final response = await _apiService.get(ApiEndpoints.myProfile);
      final data = ApiErrorHandler.handleResponse(response);

      // افتراض أن البيانات تأتي داخل 'data' أو مباشرة
      final Map<String, dynamic> responseData = data['data'] ?? data;

      return ProfileModel.fromJson(responseData);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
