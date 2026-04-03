// مسار الملف: lib/features/commissions/models/provider_commission_summary_model.dart

class ProviderCommissionSummaryModel {
  final double totalDueCommission; // إجمالي مبالغ العمولات المطلوبة
  final double totalPaidAlready;    // المبالغ المدفوعة سلفاً
  final double currentBalance;      // الرصيد المتبقي (المديونية)

  ProviderCommissionSummaryModel({
    required this.totalDueCommission,
    required this.totalPaidAlready,
    required this.currentBalance,
  });

  factory ProviderCommissionSummaryModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? json;
    return ProviderCommissionSummaryModel(
      totalDueCommission: double.tryParse(summary['total_due_commission']?.toString() ?? '0.0') ?? 0.0,
      totalPaidAlready: double.tryParse(summary['total_paid_already']?.toString() ?? '0.0') ?? 0.0,
      currentBalance: double.tryParse(summary['current_balance']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
