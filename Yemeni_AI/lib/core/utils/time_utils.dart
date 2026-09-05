// القسم الخامس: أدوات التعامل مع الوقت والتفاصيل الزمنية
class TimeUtils {
  // تنسيق الطوابع الزمنية للرسائل (اليوم / أمس / التاريخ الكامل)
  static String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(time.year, time.month, time.day);
    
    if (msgDate == today) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (msgDate == today.subtract(const Duration(days: 1))) {
      return 'أمس ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // تنسيق الساعة الحية للهيدر
  static String formatLiveClock() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  // حساب الفرق الزمني لعرض فاصل "فترة راحة طويلة"
  static bool isLongBreak(DateTime lastMsgTime, DateTime currentMsgTime) {
    return currentMsgTime.difference(lastMsgTime).inMinutes > 60;
  }
}
