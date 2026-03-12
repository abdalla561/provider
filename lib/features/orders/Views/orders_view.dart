// مسار الملف: lib/features/orders/views/orders_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../viewmodels/orders_viewmodel.dart';
import '../models/order_model.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrdersViewModel(),
      child: const _OrdersBody(),
    );
  }
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OrdersViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // لون خلفية الشاشة الفاتح
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('incoming_orders') ?? 'الطلبات الواردة',
          style: TextStyle(color: context.qsColors.text, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: context.qsColors.text), // حسب الصورة السهم لليمين في العربي
            onPressed: () {}, 
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.filter_list_rounded, color: context.qsColors.text),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          // 1. شريط التبويبات (الكل، جديد، قيد التنفيذ، مكتمل)
          _buildTabs(context, viewModel),
          
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // 2. قائمة الطلبات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.filteredOrders.length,
              itemBuilder: (context, index) {
                return _OrderCardWidget(order: viewModel.filteredOrders[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, OrdersViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(viewModel.tabs.length, (index) {
          final isSelected = viewModel.selectedTabIndex == index;
          return GestureDetector(
            onTap: () => viewModel.changeTab(index),
            child: Container(
              margin: const EdgeInsets.only(left: 8), // مسافة بين التبويبات
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1CB0F6) : Colors.white, // أزرق إذا محدد، أبيض إذا لا
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Text(
                context.tr(viewModel.tabs[index]) ?? viewModel.tabs[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ==========================================
// تصميم كرت الطلب (Order Card)
// ==========================================
class _OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  const _OrderCardWidget({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الهيدر (حالة الطلب + الوقت)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 16, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(
                    order.timeAgo,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
              _buildStatusBadge(context, order.status),
            ],
          ),
          const SizedBox(height: 16),

          // 2. معلومات العميل والسعر
          Row(
            children: [
              // السعر (يسار)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.oldPrice != null)
                    Text(
                      '${order.oldPrice?.toInt()} ${context.tr('currency_sar')}',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        decoration: TextDecoration.lineThrough, // خط شطب
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${context.tr('currency_sar')} ',
                        style: const TextStyle(color: Color(0xFF1CB0F6), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.price.toInt()}',
                        style: const TextStyle(color: Color(0xFF1CB0F6), fontSize: 24, fontWeight: FontWeight.bold, height: 1),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              // الاسم والخدمة (يمين)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.customerName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    order.serviceName,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // الصورة الرمزية (أقصى اليمين)
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: order.customerImage.isNotEmpty ? NetworkImage(order.customerImage) : null,
                    child: order.customerImage.isEmpty
                        ? Icon(Icons.person, color: Colors.grey.shade400, size: 30)
                        : null,
                  ),
                  if (order.isVerified)
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified, color: Color(0xFF1CB0F6), size: 18),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. مربع التفاصيل (الموقع والوصف)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order.location,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                if (order.description != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.description, size: 18, color: Colors.grey.shade500),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          order.description!,
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. الأزرار (تتغير حسب الحالة)
          _buildActionButtons(context, order.status),
        ],
      ),
    );
  }

  // بناء شريط الحالة (جديد، قيد التنفيذ...)
  Widget _buildStatusBadge(BuildContext context, OrderStatus status) {
    Color bgColor;
    Color textColor;
    String textKey;

    switch (status) {
      case OrderStatus.newOrder:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1CB0F6);
        textKey = 'new_order';
        break;
      case OrderStatus.inProgress:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFF57C00);
        textKey = 'in_progress';
        break;
      case OrderStatus.completed:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF388E3C);
        textKey = 'completed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        context.tr(textKey) ?? '',
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  // بناء الأزرار السفلية بناءً على حالة الطلب
  Widget _buildActionButtons(BuildContext context, OrderStatus status) {
    if (status == OrderStatus.newOrder) {
      return Row(
        children: [
          // زر الرفض
          Container(
            height: 45,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          // زر التعديل (إذا كان فيه مساحة أو نظهره بناء على التصميم)
          Expanded(
            flex: 2,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit, color: Colors.black87, size: 18),
                label: Text(
                  context.tr('edit') ?? 'تعديل',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // زر القبول
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CB0F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                label: Text(
                  context.tr('accept') ?? 'قبول',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (status == OrderStatus.inProgress) {
      return Row(
        children: [
          // زر المراسلة
          Expanded(
            flex: 2,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1CB0F6), size: 18),
                label: Text(
                  context.tr('message') ?? 'مراسلة',
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // زر اكتمال الطلب
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 45,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745), // لون أخضر
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                label: Text(
                  context.tr('complete_order') ?? 'اكتمال الطلب',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      );
    }
    
    // في حالة مكتمل لا نعرض أزرار (أو حسب رغبتك)
    return const SizedBox.shrink(); 
  }
}