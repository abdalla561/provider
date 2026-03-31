// مسار الملف: lib/features/commissions/views/widgets/reward_points_card.dart

import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';

class RewardPointsCard extends StatelessWidget {
  final int pointsBalance;

  const RewardPointsCard({
    super.key,
    this.pointsBalance = 150, // قيمة افتراضية للتصميم
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // التسمية والأيقونة (في البداية)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0), // برتقالي فاتح
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFFCC80)),
                    ),
                    child: const Icon(
                      Icons.stars_rounded,
                      color: Color(0xFFFFA000), // برتقالي/ذهبي
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.tr('reward_points'),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(width: 16),
              
              // الرصيد (في النهاية)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pointsBalance.toString(),
                    style: const TextStyle(
                      color: Color(0xFFE68A00), // لون برتقالي/ذهبي حسب الصورة
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    context.tr('points'),
                    style: const TextStyle(
                      color: Color(0xFFE68A00),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // النص التوضيحي بالأسفل
          Text(
            context.tr('redeem_points_subtitle'),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
