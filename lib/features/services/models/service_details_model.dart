// مسار الملف: lib/features/services/models/service_details_model.dart

class ServiceDetailsModel {
  final int id;
  final int categoryId;
  final String title;
  final String description;
  final String priceText;
  final String status;
  final String imageUrl;
  final String categoryName;
  final List<SubServiceDetailModel> subServices;

  ServiceDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priceText,
    required this.status,
    required this.imageUrl,
    required this.categoryName,
    required this.subServices,
    required this.categoryId,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    String currentStatus = 'غير نشط';
    if (json['is_active'] == true || json['status'] == 'available') {
      currentStatus = 'نشط';
    }

    final categoryData = json['category'];
    String catName = categoryData != null
        ? (categoryData['name'] ?? 'بدون فئة')
        : 'بدون فئة';

    //
    String rawImagePath = json['image_path'] ?? json['image_url'] ?? '';
    String finalImageUrl = '';

    if (rawImagePath.isNotEmpty) {
      if (rawImagePath.startsWith('http')) {
        finalImageUrl = rawImagePath;
      } else {
        // إضافة رابط السيرفر المحلي لكي يفهم فلاتر أنه رابط إنترنت وليس ملف محلي
        finalImageUrl = 'http://127.0.0.1:8000/storage/$rawImagePath';
      }
    }

    final List childList = json['children'] ?? json['child_services'] ?? [];

    return ServiceDetailsModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? '',
      description: json['description'] ?? 'لا يوجد وصف متاح لهذه الخدمة.',
      priceText: '${json['price'] ?? 0} ر.س',
      status: currentStatus,
      imageUrl: finalImageUrl,
      categoryName: catName,
      subServices: childList
          .map((e) => SubServiceDetailModel.fromJson(e))
          .toList(),
      categoryId: json['category_id'] ?? 0,
    );
  }
}

class SubServiceDetailModel {
  final int id;
  final String name;
  final String priceText;
  final int categoryId;

  SubServiceDetailModel({
    required this.id,
    required this.name,
    required this.priceText,
    required this.categoryId,
  });

  factory SubServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return SubServiceDetailModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      priceText: '${json['price'] ?? 0} ر.س',
      categoryId: json['category_id'] ?? 0,
    );
  }
}
