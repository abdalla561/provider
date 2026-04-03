class PhoneModel {
  final int id;
  final String phone;
  final String countryCode;
  final String type; // mobile, whatsapp, both
  final bool isPrimary;

  PhoneModel({
    required this.id,
    required this.phone,
    required this.countryCode,
    required this.type,
    required this.isPrimary,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      id: json['id'] ?? 0,
      phone: json['phone']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '+966',
      type: json['type']?.toString() ?? 'mobile',
      isPrimary: json['is_primary'] == 1 || json['is_primary'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'country_code': countryCode,
      'type': type,
      'is_primary': isPrimary ? 1 : 0,
    };
  }
}
