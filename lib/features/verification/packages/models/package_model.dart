// مسار الملف: lib/features/packages/models/package_model.dart

class PackageModel {
  final int id;
  final String title;
  final String duration;
  final double price; // 🚀 هنا موجود السعر الصحيح
  final List<String> features;
  final String? badgeText;
  final bool isPopular; // 🚀 وهنا موجودة isPopular الصحيحة

  PackageModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.price,
    required this.features,
    this.badgeText,
    this.isPopular = false,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json, int index) {
    bool isPop = index == 1;

    List<String> parsedFeatures = [];
    if (json['features'] != null && json['features'] is List) {
      parsedFeatures = List<String>.from(json['features']);
    } else {
      parsedFeatures = ['شارة توثيق مميزة', 'أولوية في البحث', 'دعم فني مخصص'];
    }

    return PackageModel(
      id: json['id'] ?? 0,
      title: json['name'] ?? json['title'] ?? 'باقة توثيق',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      duration:
          json['duration'] ??
          json['description'] ??
          'خيار ممتاز لزيادة الموثوقية',
      features: parsedFeatures,
      badgeText: json['badge'] ?? (isPop ? 'الأكثر طلباً' : 'باقة مميزة'),
      isPopular: isPop,
    );
  }
}
