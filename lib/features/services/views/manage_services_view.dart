// مسار الملف: lib/features/services/views/manage_services_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/features/services/views/add_service_view.dart';
import 'package:service_provider_app/features/services/widgets/service_card_widget.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../../home/viewmodels/main_viewmodel.dart';
import '../viewmodels/manage_services_viewmodel.dart';

class ManageServicesView extends StatelessWidget {
  const ManageServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ManageServicesViewModel>(context);
    final mainViewModel = Provider.of<MainViewModel>(context, listen: false);

    final filters = ['الكل', 'نشط', 'غير نشط'];

    return SafeArea(
      child: Column(
        children: [
          // 1. الهيدر
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddServiceView()),
                    );
                  },
                  child: Text(
                    'اضافة خدمة',
                    style: TextStyle(
                      color: context.qsColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'إدارة خدماتي',
                  style: TextStyle(
                    color: context.qsColors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // IconButton(
                //   onPressed: () => mainViewModel.changeTab(0), // يعود للرئيسية
                //   icon: Icon(Icons.arrow_forward, color: context.qsColors.text),
                // ),
                SizedBox(width: 0),
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => await viewModel.fetchServices(),
              color: context.qsColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // 2. شريط البحث
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: 'بحث عن خدمة...',
                          hintStyle: TextStyle(
                            color: context.qsColors.textSub.withOpacity(0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: context.qsColors.textSub,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. أزرار الفلترة
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Row(
                        children: List.generate(filters.length, (index) {
                          final isSelected =
                              viewModel.selectedFilterIndex == index;
                          return GestureDetector(
                            onTap: () => viewModel.changeFilter(index),
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.qsColors.text
                                    : Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : context.qsColors.textSub.withOpacity(
                                          0.2,
                                        ),
                                ),
                              ),
                              child: Text(
                                filters[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).cardColor
                                      : context.qsColors.textSub,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. الحالات (تحميل، خطأ، أو عرض البيانات)
                    if (viewModel.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: CircularProgressIndicator(),
                      )
                    else if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else if (viewModel.filteredServices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text('لا توجد خدمات حالياً.'),
                      )
                    else
                      ...viewModel.filteredServices.map(
                        (service) => ServiceCardWidget(service: service),
                      ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
