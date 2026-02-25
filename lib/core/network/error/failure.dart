
/// 📝 الوصف: كلاس بسيط يمثل الخطأ.
/// يحتوي على الرسالة التي ستعرض للمستخدم.
class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() => message;
}
