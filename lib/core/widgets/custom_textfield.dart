
import 'package:flutter/material.dart';
import '../../core/theme/qs_color_extension.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // نص العنوان (Label) فوق الحقل
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: context.qsColors.text,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 8),
        
        // حقل الإدخال
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          style: TextStyle(color: context.qsColors.text, fontFamily: 'Cairo'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.qsColors.textSub.withOpacity(0.5)),
            filled: true,
            fillColor: context.qsColors.text.withOpacity(0.03), // لون خلفية خفيف جداً
            
            // الأيقونة اليمنى (Prefix)
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: context.qsColors.textSub.withOpacity(0.7))
                : null,
            
            // الأيقونة اليسرى (Suffix - لزر العين في كلمة المرور)
            suffixIcon: suffixIcon,
            
            // تصميم الحدود
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.qsColors.textSub.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.qsColors.textSub.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: context.qsColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}