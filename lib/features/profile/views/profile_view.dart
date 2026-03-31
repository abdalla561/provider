// مسار الملف: lib/features/profile/views/profile_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/qs_color_extension.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.qsColors;
    final vm = context.watch<ProfileViewModel>();
    final bgColor = const Color(0xFFF8F9FA); // الخلفية من التصميم

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(context, vm, colors, bgColor),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5CA4B8)))
          : vm.errorMessage != null
              ? Center(child: Text(vm.errorMessage!, style: const TextStyle(color: Colors.red)))
              : vm.profile == null
                  ? const SizedBox()
                  : DefaultTabController(
                      length: 3, // عدد التبويبات
                      child: Column(
                        children: [
                          // 👤 الجزء العلوي (معلومات الحساب)
                          _buildProfileHeader(context, vm.profile!, colors),
                          const SizedBox(height: 24),
                          
                          // 🔘 أزرار التعديل والمشاركة
                          _buildActionButtons(context, colors),
                          const SizedBox(height: 24),

                          // 📑 شريط التبويبات (Tabs)
                          _buildTabBar(context, colors),
                          
                          // 🖼️ محتوى التبويبات (Grid الأعمال)
                          Expanded(
                            child: TabBarView(
                              children: [
                                _buildWorksTab(context, vm.profile!.worksImages), // الأعمال
                                const Center(child: Text('الخدمات قريباً')), // الخدمات
                                const Center(child: Text('التقييمات قريباً')), // التقييمات
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }

  // ========================================================
  // 🧩 Widgets التصميم الفرعية
  // ========================================================

  AppBar _buildAppBar(BuildContext context, ProfileViewModel vm, dynamic colors, Color bgColor) {
    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        vm.profile?.username ?? '...',
        style: TextStyle(color: colors.text, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      leading: IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.blue), // أيقونة القائمة الزرقاء
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.arrow_forward, color: colors.text), // السهم لدعم الـ RTL
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic profile, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // الإحصائيات والصورة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(context, '${profile.yearsExperience}+', context.tr('years_experience'), colors),
              _buildStatItem(context, '${profile.rating}', context.tr('rating'), colors),
              _buildStatItem(context, '${profile.completedJobs}', context.tr('completed_jobs'), colors),
              
              // الصورة الدائرية مع إطار أزرق
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF5CA4B8), width: 3),
                  image: profile.avatarUrl.isNotEmpty
                      ? DecorationImage(image: NetworkImage(profile.avatarUrl), fit: BoxFit.cover)
                      : const DecorationImage(image: AssetImage('assets/images/default_avatar.png'), fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الاسم والمسمى الوظيفي
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  profile.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colors.text),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.jobTitle,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF5CA4B8), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // النبذة التعريفية (Bio)
          Text(
            profile.bio.isNotEmpty ? profile.bio : 'متخصص في صيانة وتركيب جميع أنواع وحدات التكييف. فني معتمد منذ عام 2018. نسعى دائماً لتقديم أفضل مستويات الراحة لمنزلك بجودة وإتقان.',
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13, color: colors.textSub, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, dynamic colors) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.text),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF5CA4B8)),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, dynamic colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5CA4B8),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                context.tr('edit_profile'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE5E7EB), // رمادي فاتح
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                context.tr('share_profile'),
                style: TextStyle(color: colors.text, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, dynamic colors) {
    return TabBar(
      labelColor: const Color(0xFF5CA4B8),
      unselectedLabelColor: colors.textSub,
      indicatorColor: const Color(0xFF5CA4B8),
      indicatorWeight: 3,
      tabs: [
        Tab(icon: const Icon(Icons.grid_view_rounded), text: context.tr('tab_works')),
        Tab(icon: const Icon(Icons.build_rounded), text: context.tr('tab_services')),
        Tab(icon: const Icon(Icons.star_rate_rounded), text: context.tr('tab_reviews')),
      ],
    );
  }

  // 🖼️ شبكة الصور (مربع الإضافة + صور الأعمال)
  Widget _buildWorksTab(BuildContext context, List<String> images) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1, // مربعات متساوية
      ),
      itemCount: images.length + 1, // +1 لزر إضافة صورة
      itemBuilder: (context, index) {
        if (index == 0) {
          // زر إضافة عمل جديد
          return Container(
            color: const Color(0xFFE4F3F8), // أزرق فاتح جداً
            child: const Center(
              child: Icon(Icons.add_a_photo_outlined, color: Color(0xFF5CA4B8), size: 32),
            ),
          );
        }
        
        // عرض الصور
        final imageUrl = images[index - 1];
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }
}