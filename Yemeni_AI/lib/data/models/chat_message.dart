// القسم الثاني والخامس: نموذج بيانات الرسالة والتفاصيل الزمنية
class ChatMessage {
  final String id;          // معرف فريد للرسالة
  final String content;     // محتوى الرسالة (النص)
  final bool isUser;        // هل المرسل هو المستخدم؟ (true) أم الذكاء الاصطناعي؟ (false)
  final DateTime timestamp; // الوقت الدقيق للإرسال (القسم الخامس)
  final double? latency;    // مدة تفكير الذكاء الاصطناعي بالثواني (Latency Badge)
  final MessageStatus status; // حالة الرسالة (جاري الإرسال، تم، فشل)

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.latency,
    this.status = MessageStatus.sent,
  });
}

// حالات الرسالة المحتملة
enum MessageStatus {
  sending,  // جاري الإرسال
  sent,     // تم الإرسال
  received, // تم الاستلام والرد
  error     // فشل
}
