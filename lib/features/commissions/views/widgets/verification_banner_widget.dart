// // مسار الملف: lib/features/commissions/views/widgets/verification_banner_widget.dart

// import 'package:flutter/material.dart';
// import '../../../../core/localization/app_localizations.dart';
// import '../../../../core/theme/qs_color_extension.dart';

// class VerificationBannerWidget extends StatelessWidget {
//   const VerificationBannerWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFEAF5FA), // لون أزرق فاتح جداً (Light blue background)
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.blue.withOpacity(0.1)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // زر "وثق الآن" (يسار)
//           ElevatedButton(
//             onPressed: () {
//               // TODO: الانتقال لشاشة التوثيق
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF1CB0F6), // الأزرق الرئيسي الزاهي
//               foregroundColor: Colors.white,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             ),
//             child: Text(
//               context.tr('verify_now'),
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),

//           const SizedBox(width: 12),

//           // النصوص (الوسط)
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   context.tr('verify_account_banner_title'),
//                   style: TextStyle(
//                     color: context.qsColors.text,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   context.tr('verify_account_banner_subtitle'),
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 12),

//           // الأيقونة الدائرية الزرقاء (يمين)
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: const BoxDecoration(
//               color: Color(0xFF1CB0F6),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.verified_user_rounded,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// مسار الملف: lib/features/commissions/views/widgets/verification_banner_widget.dart

import 'package:flutter/material.dart';
import 'package:service_provider_app/features/verification/widgets/verification_options_dialog.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/qs_color_extension.dart';

// 🚀 1. أضف مسار استيراد الـ Dialog هنا (تأكد من تعديل المسار ليطابق مكان الملف في مشروعك)
// import '../../verification/widgets/verification_options_dialog.dart';

class VerificationBannerWidget extends StatelessWidget {
  const VerificationBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FA), // لون أزرق فاتح جداً
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // زر "وثق الآن" (يسار)
          ElevatedButton(
            // 🚀 2. استدعاء الدالة النظيفة من الكلاس مباشرة
            onPressed: () => VerificationOptionsDialog.show(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CB0F6), // الأزرق الرئيسي الزاهي
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              context.tr('verify_now'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 12),

          // النصوص (الوسط)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  context.tr('verify_account_banner_title'),
                  style: TextStyle(
                    color: context.qsColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('verify_account_banner_subtitle'),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // الأيقونة الدائرية الزرقاء (يمين)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF1CB0F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
