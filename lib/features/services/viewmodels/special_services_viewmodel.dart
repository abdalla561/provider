import 'package:flutter/material.dart';
import '../models/manage_services_model.dart';
import '../repositories/manage_services_repository.dart';

class SpecialServicesViewModel extends ChangeNotifier {
  final ManageServicesRepository repository;

  List<ServiceModel> customServices = [];
  List<ServiceModel> meetingServices = [];

  bool isCustomLoading = true;
  bool isMeetingLoading = true;
  
  String? customError;
  String? meetingError;

  SpecialServicesViewModel(this.repository) {
    loadAllServices();
  }

  Future<void> loadAllServices() async {
    loadCustomServices();
    loadMeetingServices();
  }

  Future<void> loadCustomServices() async {
    isCustomLoading = true;
    customError = null;
    notifyListeners();

    try {
      customServices = await repository.getCustomServices();
    } catch (e) {
      customError = e.toString();
    } finally {
      isCustomLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMeetingServices() async {
    isMeetingLoading = true;
    meetingError = null;
    notifyListeners();

    try {
      meetingServices = await repository.getMeetingServices();
    } catch (e) {
      meetingError = e.toString();
    } finally {
      isMeetingLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleServiceStatus(ServiceModel service) async {
    try {
      // تحديث متفائل (Optimistic Update) في المخصصة
      int customIndex = customServices.indexWhere((s) => s.id == service.id);
      if (customIndex != -1) {
        bool newStatus = !service.isActive;
        customServices[customIndex] = _updateServiceStatus(service, newStatus);
        notifyListeners();
      }

      // تحديث متفائل في الحضور
      int meetingIndex = meetingServices.indexWhere((s) => s.id == service.id);
      if (meetingIndex != -1) {
        bool newStatus = !service.isActive;
        meetingServices[meetingIndex] = _updateServiceStatus(service, newStatus);
        notifyListeners();
      }

      // إرسال الطلب
      await repository.updateService(
        serviceId: service.id,
        isActive: !service.isActive,
      );
    } catch (e) {
      // إعادة التحديث من السيرفر في حال الفشل
      await loadAllServices();
    }
  }

  ServiceModel _updateServiceStatus(ServiceModel service, bool newStatus) {
    return ServiceModel(
      id: service.id,
      title: service.title,
      priceText: service.priceText,
      status: newStatus ? 'نشط' : 'غير نشط',
      isActive: newStatus,
      imageUrl: service.imageUrl,
      subServicesCount: service.subServicesCount,
      isExpanded: service.isExpanded,
      quickServices: service.quickServices,
    );
  }
}
