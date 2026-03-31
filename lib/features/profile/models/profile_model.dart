// مسار الملف: lib/features/profile/models/profile_model.dart

class ProfileModel {
  final String username;
  final String name;
  final String jobTitle;
  final String bio;
  final String avatarUrl;
  final int completedJobs;
  final double rating;
  final int yearsExperience;
  final List<String> worksImages;

  ProfileModel({
    required this.username,
    required this.name,
    required this.jobTitle,
    required this.bio,
    required this.avatarUrl,
    required this.completedJobs,
    required this.rating,
    required this.yearsExperience,
    required this.worksImages,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      username: json['username'] ?? 'service_provider@',
      name: json['name'] ?? 'اسم المستخدم',
      jobTitle: json['job_title'] ?? 'فني محترف',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatar'] ?? '',
      completedJobs: json['completed_jobs'] ?? 0,
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      yearsExperience: json['years_experience'] ?? 0,
      worksImages: List<String>.from(json['works'] ?? []),
    );
  }
} 