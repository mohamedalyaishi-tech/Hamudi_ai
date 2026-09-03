import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/ai_config.dart';

class ChatService {
  // رابط السيرفر الوسيط الجديد
  final String _proxyUrl = 'https://hamudi-ai.onrender.com/chat';

  Future<String> sendMessage(List<Map<String, String>> history) async {
    try {
      final response = await http.post(
        Uri.parse(_proxyUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': AIConfig.model,
          'messages': history,
          'temperature': AIConfig.temperature,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'] as String;
        return reply.replaceAll(RegExp(r'<think>.*?</think>', dotAll: true), '').trim();
      } else {
        return 'خطأ من السيرفر: ${response.statusCode}';
      }
    } catch (e) {
      return 'فشل الاتصال: $e';
    }
  }
}
