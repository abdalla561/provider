import 'package:flutter/material.dart';
import '../../core/theme/qs_color_extension.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isPrimary;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.icon,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext context) {
    // الألوان تتغير بذكاء بناءً على نوع الزر والثيم الحالي
    final bgColor = isPrimary
        ? context.qsColors.primary
        : context.qsColors.background;
    final textColor = isPrimary ? Colors.white : context.qsColors.text;
    final iconColor = isPrimary ? Colors.white : context.qsColors.primary;
    final borderColor = isPrimary
        ? Colors.transparent
        : context.qsColors.primary.withOpacity(0.2);
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: isPrimary?[BoxShadow(color: context.qsColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]:[],

      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 10),
              Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: textColor,
                      fontSize: 18,))
            ],
          ),
        ),
      ),
    );
  }
}
