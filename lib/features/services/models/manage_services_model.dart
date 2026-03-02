// مسار الملف: lib/features/services/models/manage_services_model.dart

class ServiceModel {
  final int id;
  final String title;
  final String priceText;
  final String status; 
  final String imageUrl;
  final int subServicesCount;
  final bool isExpanded;
  final List<SubServiceModel> quickServices;

  ServiceModel({
    required this.id,
    required this.title,
    required this.priceText,
    required this.status,
    required this.imageUrl,
    required this.subServicesCount,
    this.isExpanded = false,
    this.quickServices = const [],
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // تحديد حالة الخدمة (نشط/غير نشط) بناءً على حقل is_active أو status من السيرفر
    String currentStatus = 'غير نشط';
    if (json['is_active'] == true || json['status'] == 'available') {
      currentStatus = 'نشط';
    }

    // استخراج الخدمات الفرعية (إذا كان الباك اند يرسلها كمصفوفة children أو child_services)
    final List childList = json['children'] ?? json['child_services'] ?? json['quick_services'] ?? [];

    return ServiceModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? json['title'] ?? '', // السيرفر يستخدم name
      priceText: '${json['price'] ?? 0} ر.س', // دمج السعر مع العملة
      status: currentStatus,
      imageUrl: json['image_path'] ?? json['image_url'] ?? '', // السيرفر يستخدم image_path
      subServicesCount: childList.length,
      isExpanded: childList.isNotEmpty, // نفتح الكارت إذا كان هناك خدمات فرعية
      quickServices: childList.map((e) => SubServiceModel.fromJson(e)).toList(),
    );
  }
}

class SubServiceModel {
  final String name;
  final String price;

  SubServiceModel({required this.name, required this.price});

  factory SubServiceModel.fromJson(Map<String, dynamic> json) {
    return SubServiceModel(
      name: json['name'] ?? '',
      price: '${json['price'] ?? 0} ر.س',
    );
  }
}