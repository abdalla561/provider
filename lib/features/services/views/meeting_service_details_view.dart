import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_provider_app/core/network/api_client.dart';
import 'package:service_provider_app/core/storage/token_storage.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../repositories/manage_services_repository.dart';
import '../viewmodels/meeting_service_viewmodel.dart';
import 'edit_meeting_service_view.dart';

class MeetingServiceDetailsView extends StatelessWidget {
  final int serviceId;

  const MeetingServiceDetailsView({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final api = ApiService(TokenStorage());
        final repo = ManageServicesRepository(api);
        return MeetingServiceViewModel(repo, serviceId);
      },
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MeetingServiceViewModel>(context);

    return Scaffold(
      backgroundColor: context.qsColors.background,
      appBar: AppBar(
        title: Text('تفاصيل خدمة الحضور', style: TextStyle(color: context.qsColors.text, fontWeight: FontWeight.bold)),
        backgroundColor: context.qsColors.background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: context.qsColors.text, size: 20),
          onPressed: () => Navigator.pop(context, true),
        ),
        actions: [
          if (viewModel.service != null)
            IconButton(
              icon: Icon(Icons.edit, color: context.qsColors.primary),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return ChangeNotifierProvider.value(
                      value: viewModel,
                      child: const EditMeetingServiceView(),
                    );
                  }),
                );
                if (result == true) {
                  viewModel.fetchDetails();
                }
              },
            ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage != null
              ? Center(child: Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الحالة
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'الحالة: ${viewModel.service!.status}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: viewModel.service!.isActive ? Colors.green : context.qsColors.textSub,
                              ),
                            ),
                            Icon(
                              viewModel.service!.isActive ? Icons.check_circle : Icons.cancel,
                              color: viewModel.service!.isActive ? Colors.green : context.qsColors.textSub,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // السعر الأساسي وسعر الكيلو
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              context,
                              title: 'سعر الخدمة',
                              value: viewModel.service!.priceText,
                              icon: Icons.attach_money,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildInfoCard(
                              context,
                              title: 'سعر الكيلومتر',
                              value: '${viewModel.service!.pricePerKm} ر.س',
                              icon: Icons.directions_car,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // الوصف
                      Text(
                        'وصف الخدمة',
                        style: TextStyle(color: context.qsColors.primary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
                        ),
                        child: Text(
                          viewModel.service!.description.isNotEmpty ? viewModel.service!.description : 'لا يوجد وصف حالياً.',
                          style: TextStyle(color: context.qsColors.text, fontSize: 15, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.qsColors.textSub.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.qsColors.primary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: context.qsColors.textSub, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: context.qsColors.text, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
