// مسار الملف: lib/features/orders/models/order_model.dart

enum OrderStatus { newOrder, inProgress, completed }

class OrderModel {
  final String id;
  final String customerName;
  final String serviceName;
  final String customerImage;
  final bool isVerified;
  final double price;
  final double? oldPrice;
  final String location;
  final String? description;
  final String timeAgo;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.customerImage,
    this.isVerified = false,
    required this.price,
    this.oldPrice,
    required this.location,
    this.description,
    required this.timeAgo,
    required this.status,
  });

  // 🚀 دالة تحويل الـ JSON القادم من السيرفر إلى مودل
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // تحديد حالة الطلب بناءً على الكلمة القادمة من الباك اند (عدلها حسب ما يرسله الباك اند)
    OrderStatus currentStatus = OrderStatus.newOrder;
    String rawStatus = json['status'] ?? 'pending';

    if (rawStatus == 'pending' || rawStatus == 'new') {
      currentStatus = OrderStatus.newOrder;
    } else if (rawStatus == 'accepted' || rawStatus == 'in_progress') {
      currentStatus = OrderStatus.inProgress;
    } else if (rawStatus == 'completed' || rawStatus == 'finished') {
      currentStatus = OrderStatus.completed;
    }

    // استخراج اسم العميل وصورته (نفترض أنها تأتي داخل كائن user أو customer)
    final userData = json['user'] ?? json['customer'] ?? {};
    final serviceData = json['service'] ?? {};

    return OrderModel(
      id: json['id']?.toString() ?? '',
      customerName: userData['name'] ?? 'عميل',
      customerImage:
          userData['image_path'] ?? userData['avatar'] ?? '', // مسار الصورة
      serviceName: serviceData['name'] ?? 'خدمة عامة',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      location: json['location'] ?? 'الموقع غير محدد',
      description: json['notes'] ?? json['description'],
      timeAgo: json['created_at'] ?? '', // يفضل استخدام مكتبة timeago لاحقاً
      status: currentStatus,
      isVerified:
          userData['is_verified'] == 1 || userData['is_verified'] == true,
    );
  }
}
