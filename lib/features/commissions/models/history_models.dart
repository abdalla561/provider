// مسار الملف: lib/features/commissions/models/history_models.dart

enum HistoryType { package, point, withdrawal, bond, commission }

abstract class BaseHistoryItem {
  final String id;
  final String title;
  final String date;
  final double amount;
  final String status;
  final HistoryType type;

  BaseHistoryItem({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
  });
}

/// 📦 مودل باقات النقاط المشتراة
class PointsPackageHistoryModel extends BaseHistoryItem {
  PointsPackageHistoryModel({
    required super.id,
    required super.title,
    required super.date,
    required super.amount,
    required super.status,
  }) : super(type: HistoryType.package);

  factory PointsPackageHistoryModel.fromJson(Map<String, dynamic> json) {
    return PointsPackageHistoryModel(
      id: json['id']?.toString() ?? '',
      title: json['package_name'] ?? json['title'] ?? 'باقة نقاط',
      date: json['created_at'] ?? '',
      amount: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'completed',
    );
  }
}

/// 🔄 مودل عمليات النقاط (تحويل/استهلاك)
class PointsTransactionModel extends BaseHistoryItem {
  PointsTransactionModel({
    required super.id,
    required super.title,
    required super.date,
    required super.amount,
    required super.status,
  }) : super(type: HistoryType.point);

  factory PointsTransactionModel.fromJson(Map<String, dynamic> json) {
    return PointsTransactionModel(
      id: json['id']?.toString() ?? '',
      title: json['description'] ?? json['type'] ?? 'عملية نقاط',
      date: json['created_at'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'completed',
    );
  }
}

/// 📤 مودل طلبات سحب الأرباح
class WithdrawRequestModel extends BaseHistoryItem {
  WithdrawRequestModel({
    required super.id,
    required super.title,
    required super.date,
    required super.amount,
    required super.status,
  }) : super(type: HistoryType.withdrawal);

  factory WithdrawRequestModel.fromJson(Map<String, dynamic> json) {
    return WithdrawRequestModel(
      id: json['id']?.toString() ?? '',
      title: 'طلب سحب أرباح',
      date: json['created_at'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'pending',
    );
  }
}

/// 📄 مودل سندات دفع العمولة
class ProviderRequestBondModel extends BaseHistoryItem {
  ProviderRequestBondModel({
    required super.id,
    required super.title,
    required super.date,
    required super.amount,
    required super.status,
  }) : super(type: HistoryType.bond);

  factory ProviderRequestBondModel.fromJson(Map<String, dynamic> json) {
    return ProviderRequestBondModel(
      id: json['id']?.toString() ?? '',
      title: 'سند دفع عمولة (${json['number_bond'] ?? ''})',
      date: json['created_at'] ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      status: json['status'] ?? 'pending',
    );
  }
}
