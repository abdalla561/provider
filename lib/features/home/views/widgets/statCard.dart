import 'package:flutter/material.dart';
import '../../../../core/theme/qs_color_extension.dart';
// 1. كارت الإحصائيات (أرباح الأسبوع / التقييم)
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary ? context.qsColors.primary : Theme.of(context).cardColor;
    final textColor = isPrimary ? Colors.white : context.qsColors.text;
    final subTextColor = isPrimary ? Colors.white.withOpacity(0.8) : context.qsColors.textSub;
    final iconBgColor = isPrimary ? Colors.white.withOpacity(0.2) : Colors.amber.withOpacity(0.1);
    final iconColor = isPrimary ? Colors.white : Colors.amber;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isPrimary ? context.qsColors.primary.withOpacity(0.3) : Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: subTextColor, fontSize: 13, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: TextStyle(color: textColor, fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(width: 4),
                Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}