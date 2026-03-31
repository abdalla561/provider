// import 'package:flutter/material.dart';
// import '../../../core/localization/app_localizations.dart';
// import '../../../core/theme/qs_color_extension.dart';

// /// 📂 اسم الملف: verification_options_dialog.dart
// /// 📝 الوصف: نافذة منبثقة تعرض خيارات توثيق الحساب (جديد / تجديد).
// class VerificationOptionsDialog extends StatelessWidget {
//   const VerificationOptionsDialog({super.key});

// // // دالة مساعدة لفتح الـ Dialog
// // void showVerificationOptions(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     barrierDismissible: true, // لإغلاق النافذة عند الضغط خارجها
// //     builder: (BuildContext context) {
// //       return const VerificationOptionsDialog();
// //     },
// //   );
// // }
// static void show(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return const VerificationOptionsDialog();
//       },
//     );
//   }

// // ---------------- مثال للاستخدام داخل زر ----------------
// // ElevatedButton(
// //   onPressed: () => showVerificationOptions(context),
// //   child: Text('توثيق الحساب'),
// // )

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.qsColors;

//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//       ),
//       backgroundColor: colors.background, // يدعم الوضع الداكن والفاتح
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // لتأخذ النافذة حجم المحتوى فقط
//           children: [
//             // 🛡️ 1. الأيقونة العلوية
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: colors.primary.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.verified_user_rounded,
//                 color: colors.primary,
//                 size: 36,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 📝 2. العنوان
//             Text(
//               context.tr('verification_options_title'),
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: colors.text,
//                 fontFamily: 'Cairo',
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),

//             // 📄 3. الوصف
//             Text(
//               context.tr('verification_options_subtitle'),
//               style: TextStyle(
//                 fontSize: 13,
//                 color: colors.textSub,
//                 height: 1.6,
//                 fontFamily: 'Cairo',
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),

//             // 🔘 4. زر "طلب توثيق جديد" (Primary Button)
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // 🚀 Todo: الانتقال إلى شاشة طلب التوثيق الجديد
//                   // Navigator.pushNamed(context, Routes.newVerificationRequest);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: colors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.post_add_rounded, color: Colors.white, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       context.tr('new_verification_request'),
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         fontFamily: 'Cairo',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),

//             // 🔘 5. زر "تجديد التوثيق الحالي" (Outlined Button)
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // 🚀 Todo: الانتقال إلى شاشة التجديد
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: colors.primary, width: 1.5),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.refresh_rounded, color: colors.primary, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       context.tr('renew_current_verification'),
//                       style: TextStyle(
//                         color: colors.primary,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         fontFamily: 'Cairo',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),

//             // ❌ 6. زر "إلغاء" (Text Button)
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 context.tr('cancel'),
//                 style: TextStyle(
//                   color: colors.primary,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// مسار الملف: lib/features/verification/widgets/verification_options_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/features/verification/packages/repositories/packages_repository.dart';
import 'package:service_provider_app/features/verification/packages/viewmodels/packages_viewmodel.dart';
import 'package:service_provider_app/features/verification/packages/views/verification_packages_view.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';

// 🚀 الاستيرادات المطلوبة لفتح صفحة الباقات
import '../../../core/network/api_client.dart'; // تأكد من مسار ApiService لديك

/// 📂 اسم الملف: verification_options_dialog.dart
/// 📝 الوصف: نافذة منبثقة تعرض خيارات توثيق الحساب (جديد / تجديد).
class VerificationOptionsDialog extends StatelessWidget {
  const VerificationOptionsDialog({super.key});

  // 🚀 دالة الفتح السحرية
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const VerificationOptionsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.qsColors;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colors.background, // يدعم الوضع الداكن والفاتح
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // لتأخذ النافذة حجم المحتوى فقط
          children: [
            // 🛡️ 1. الأيقونة العلوية
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.verified_user_rounded,
                color: colors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            // 📝 2. العنوان
            Text(
              context.tr('verification_options_title'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.text,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // 📄 3. الوصف
            Text(
              context.tr('verification_options_subtitle'),
              style: TextStyle(
                fontSize: 13,
                color: colors.textSub,
                height: 1.6,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // 🔘 4. زر "طلب توثيق جديد" (Primary Button)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 1. إغلاق النافذة المنبثقة
                  Navigator.pop(context);

                  // 2. 🚀 الانتقال لشاشة الباقات مع تفعيل الـ ViewModel حقها
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => PackagesViewModel(
                          PackagesRepository(
                            context.read<ApiService>(),
                          ), // حقن الـ Repository
                        ),
                        child: const VerificationPackagesView(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.post_add_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('new_verification_request'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 🔘 5. زر "تجديد التوثيق الحالي" (Outlined Button)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // 🚀 سيتم برمجته لاحقاً عند العمل على شاشة التجديد
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: colors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('renew_current_verification'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ❌ 6. زر "إلغاء" (Text Button)
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.tr('cancel'),
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
