import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 جاري فحص الاتصال بسيرفر Render...');
  
  try {
    final response = await http.post(
      Uri.parse('https://hamudi-ai.onrender.com/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': 'qwen-3.6-27b',
        'messages': [
          {'role': 'system', 'content': 'أنت حمودي AI.'},
          {'role': 'user', 'content': 'مرحبا'}
        ],
        'temperature': 0.7
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ نجح الاتصال! السيرفر رد بنجاح.');
      print(' الرد: ${data['choices'][0]['message']['content']}');
    } else {
      print('⚠️ السيرفر رد ولكن بحالة: ${response.statusCode}');
      print('التفاصيل: ${response.body}');
    }
  } catch (e) {
    print('❌ فشل الاتصال: $e');
    print(' تأكد من أن الإنترنت متصل وأن رابط Render صحيح.');
  }
}
