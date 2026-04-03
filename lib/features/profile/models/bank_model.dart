// مودل يمثل البنوك المتوفرة في النظام 5.1
class SystemBankModel {
  final int id;
  final String name;

  SystemBankModel({required this.id, required this.name});

  factory SystemBankModel.fromJson(Map<String, dynamic> json) {
    return SystemBankModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? json['bank_name']?.toString() ?? 'غير معروف',
    );
  }
}

// مودل يمثل حساب المستخدم المربوط بالبنك (5.2)
class BankModel {
  final int id; // ID البنك
  final int bankId; // رقم البنك في النظام (5.1)
  final String bankName; // اسم البنك الأساسي
  final String accountNumber; // رقم الحساب المستخرج من الـ pivot
  final bool isActive; // حالة النشاط

  BankModel({
    required this.id,
    required this.bankId,
    required this.bankName,
    required this.accountNumber,
    this.isActive = true,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    // Debug: طباعة البيانات الواردة
    // ignore: avoid_print
    print('🏦 BankModel.fromJson keys: ${json.keys.toList()}, data: $json');

    String extractedAccount = '';
    int extractedBankId = 0;
    int extractedId = 0;
    String extractedName = 'اسم البنك غير متوفر';

    // الحالة 1: البيانات داخل pivot (علاقة many-to-many في لارافل)
    if (json.containsKey('pivot') && json['pivot'] is Map) {
      final pivot = json['pivot'] as Map;
      extractedAccount = pivot['bank_account']?.toString() ?? '';
      extractedBankId = int.tryParse(pivot['bank_id']?.toString() ?? '') ?? 0;
      // في هذه الحالة id هو id البنك في جدول banks
      extractedId = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    }
    // الحالة 2: البيانات مباشرة (user_bank record)
    else {
      extractedAccount = json['bank_account']?.toString() ?? json['account_number']?.toString() ?? '';
      extractedBankId = int.tryParse(json['bank_id']?.toString() ?? '') ?? 0;
      // id هنا هو id السجل في جدول user_banks
      extractedId = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    }

    // استخراج اسم البنك
    extractedName = json['bank_name']?.toString() ??
        json['name']?.toString() ??
        (json['bank'] is Map ? json['bank']['name']?.toString() : null) ??
        'اسم البنك غير متوفر';

    // استخراج حالة النشاط
    bool active = true;
    if (json.containsKey('pivot') && json['pivot'] is Map) {
      active = json['pivot']['is_active'] == 1 || json['pivot']['is_active'] == true;
    } else {
      active = json['is_active'] == 1 || json['is_active'] == true;
    }

    return BankModel(
      id: extractedId,
      bankId: extractedBankId > 0 ? extractedBankId : extractedId,
      bankName: extractedName,
      accountNumber: extractedAccount,
      isActive: active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': bankName,
      'pivot': {
        'bank_account': accountNumber,
      }
    };
  }
}
