// مسار الملف: lib/features/services/views/widgets/service_card_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/features/services/models/manage_services_model.dart';
import 'package:service_provider_app/features/services/viewmodels/manage_services_viewmodel.dart';
import 'package:service_provider_app/features/services/views/service_details_view.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/qs_color_extension.dart';

class ServiceCardWidget extends StatelessWidget {
  final ServiceModel service;

  const ServiceCardWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final isActive = service.status == 'نشط';
    final statusColor = isActive ? Colors.green.shade600 : context.qsColors.textSub;
    final statusBgColor = isActive ? Colors.green.withOpacity(0.1) : context.qsColors.textSub.withOpacity(0.1);

    return GestureDetector(
      // onTap: () {
      //   // 🚀 الانتقال لشاشة التفاصيل وتمرير الـ ID
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => ServiceDetailsView(serviceId: service.id)),
      //   );
      // },

      onTap: () async {
        // ننتظر النتيجة العائدة من شاشة التفاصيل
        final shouldRefresh = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ServiceDetailsView(serviceId: service.id)),
        );

        // إذا كانت النتيجة true (يعني تم الحذف أو التعديل)، قم بتحديث القائمة
        if (shouldRefresh == true) {
           Provider.of<ManageServicesViewModel>(context, listen: false).fetchServices();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.more_horiz, color: context.qsColors.textSub),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
                        child: Text(service.status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Text(service.title, style: TextStyle(color: context.qsColors.text, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(service.priceText, style: TextStyle(color: context.qsColors.textSub, fontSize: 13)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    service.imageUrl.isNotEmpty ? service.imageUrl : 'https://via.placeholder.com/80',
                    width: 80, height: 80, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(width: 80, height: 80, color: Colors.grey.shade200),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: context.qsColors.textSub.withOpacity(0.1), height: 1),
            const SizedBox(height: 16),
            if (service.isExpanded && service.quickServices.isNotEmpty) ...[
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('خدمات فرعية سريعة', style: TextStyle(color: context.qsColors.textSub, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              ...service.quickServices.map((sub) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Text(sub.price, style: TextStyle(color: context.qsColors.textSub, fontSize: 13)),
                        const Spacer(),
                        Text(sub.name, style: TextStyle(color: context.qsColors.text, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEditButton(context),
                  Row(
                    children: [
                      Icon(Icons.arrow_back, color: context.qsColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text('إدارة الكل', style: TextStyle(color: context.qsColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEditButton(context),
                  Row(
                    children: [
                      Text('الخدمات الفرعية (${service.subServicesCount})', style: TextStyle(color: context.qsColors.textSub, fontSize: 13)),
                      const SizedBox(width: 8),
                      Icon(Icons.list_alt_rounded, color: context.qsColors.textSub, size: 20),
                    ],
                  ),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: context.qsColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Text(context.tr('edit'), style: TextStyle(color: context.qsColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Icon(Icons.edit, color: context.qsColors.primary, size: 14),
        ],
      ),
    );
  }
}