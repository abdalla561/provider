// مسار الملف: lib/core/utils/dialog_helper.dart

import 'package:flutter/material.dart';
import '../theme/qs_color_extension.dart';

class DialogHelper {
  // دالة ثابتة لاستدعاء الـ Alert من أي مكان في التطبيق
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).cardColor,
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade600, size: 28),
              const SizedBox(width: 10),
              Text(
                'تنبيه',
                style: TextStyle(color: ctx.qsColors.text, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(
            message, // الرسالة القادمة من الـ ApiErrorHandler
            style: TextStyle(color: ctx.qsColors.textSub, fontSize: 14, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ctx.qsColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Navigator.of(ctx).pop(), // إغلاق الـ Alert
              child: const Text('حسناً', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}