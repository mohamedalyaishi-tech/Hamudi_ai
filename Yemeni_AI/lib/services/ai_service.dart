import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_strings.dart';
import '../data/models/chat_message.dart';

// القسم الرابع والثامن: عقل الذكاء الاصطناعي والمعالجة الذكية
class AIService {
  // رابط سيرفر Render الوسيط (ثابت ولا يتغير)
  static const String _renderUrl = 'https://hamudi-ai.onrender.com/chat';
  
  // موديل Qwen 3.6-27b (ثابت ولا يتغير)
  static const String _modelName = 'qwen/qwen3.6-27b';

  // دالة إرسال الرسالة واستقبال الرد
  Future<ChatMessage> sendMessage(String userMessage, List<ChatMessage> history) async {
    final startTime = DateTime.now();
    
    try {
      // تحويل سجل المحادثة إلى الصيغة المطلوبة للسيرفر
      final messages = [
        {'role': 'system', 'content': AppStrings.systemPrompt},
        ...history.map((msg) => {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.content
        }),
        {'role': 'user', 'content': userMessage}
      ];

      // الاتصال بسيرفر Render
      final response = await http.post(
        Uri.parse(_renderUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _modelName,
          'messages': messages,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'] as String;
        
        // معالجة الرد: إزالة وسوم التفكير <think>...</think>
        final cleanedResponse = aiResponse.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '').trim();
        
        // حساب زمن الاستجابة (Latency Badge - القسم الخامس)
        final latency = DateTime.now().difference(startTime).inMilliseconds / 1000;

        return ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: cleanedResponse,
          isUser: false,
          timestamp: DateTime.now(),
          latency: latency,
          status: MessageStatus.received,
        );
      } else {
        throw Exception('خطأ من السيرفر: ${response.statusCode}');
      }
    } catch (e) {
      // في حالة الفشل، نرجع رسالة خطأ كرسالة من الذكاء الاصطناعي
      return ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: AppStrings.errorConnection,
        isUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.error,
      );
    }
  }
}
