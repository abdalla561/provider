// مسار الملف: lib/features/home/models/home_model.dart

class HomeDataModel {
  final double rating;
  final double weeklyEarnings;
  final List<RequestModel> newRequests;
  // يمكن إضافة قائمة الخدمات النشطة هنا بنفس الطريقة

  HomeDataModel({
    required this.rating,
    required this.weeklyEarnings,
    required this.newRequests,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      // افتراضنا لأسماء المفاتيح (عدلها لتطابق الـ API لديك)
      rating: (json['rating'] ?? 0.0).toDouble(),
      weeklyEarnings: (json['weekly_earnings'] ?? 0.0).toDouble(),
      newRequests: (json['new_requests'] as List?)?.map((e) => RequestModel.fromJson(e)).toList() ?? [],
    );
  }
}

class RequestModel {
  final int id;
  final String title;
  final String location;
  final String distance;
  final String price;
  final String imageUrl;

  RequestModel({
    required this.id, required this.title, required this.location, 
    required this.distance, required this.price, required this.imageUrl,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      distance: json['distance'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}