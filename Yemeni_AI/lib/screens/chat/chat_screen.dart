import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../widgets/chat_bubble.dart';
import '../../widgets/menu_drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isLoading) return;
    final userMessage = _controller.text.trim();
    
    setState(() {
      _messages.add({'text': userMessage, 'isUser': true});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse('https://hamudi-ai.onrender.com/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': 'qwen-3.6-27b',
          'messages': [{'role': 'user', 'content': userMessage}]
        }),
      );

      if (response.statusCode == 200) {
        String aiReply = '';
        
        // محاولة ذكية لاستخراج الرد من أي صيغة ممكنة
        try {
          final data = jsonDecode(response.body);
          
          // البحث في كل الحقول الممكنة
          if (data is Map<String, dynamic>) {
            // قائمة بكل الأسماء المحتملة لحقل الرد
            final possibleKeys = ['reply', 'response', 'answer', 'result', 'output', 'text', 'content', 'message'];
            
            for (var key in possibleKeys) {
              if (data.containsKey(key) && data[key] != null) {
                aiReply = data[key].toString();
                break;
              }
            }
            
            // إذا ما لقينا في الحقول العادية، نجرب صيغة OpenAI/Groq
            if (aiReply.isEmpty && data.containsKey('choices')) {
              try {
                aiReply = data['choices'][0]['message']['content'].toString();
              } catch (e) {}
            }
            
            // إذا لسه فاضي، نعرض كامل الرد JSON عشان نشوف الصيغة
            if (aiReply.isEmpty) {
              aiReply = '🔍 الرد الخام من السيرفر:\n${response.body}';
            }
          } else {
            aiReply = response.body; // لو كان الرد نص مباشر
          }
        } catch (e) {
          aiReply = response.body; // لو فشل فك JSON نعرض النص الخام
        }

        setState(() => _messages.add({'text': aiReply, 'isUser': false}));
      } else {
        setState(() => _messages.add({
          'text': '⚠️ خطأ (${response.statusCode}): ${response.body}', 
          'isUser': false
        }));
      }
    } catch (e) {
      setState(() => _messages.add({'text': '❌ فشل الاتصال: $e', 'isUser': false}));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset('assets/jambiya-icon.svg', height: 32, width: 32),
            const SizedBox(width: 12),
            const Text('Yemeni AI', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) => ChatBubble(text: _messages[index]['text'], isUser: _messages[index]['isUser']),
            ),
          ),
          if (_isLoading) const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: CircularProgressIndicator(color: Color(0xFFFFD700))),
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF2a2a2a),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'اسأل Yemeni AI...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF3a3a3a),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
                    child: IconButton(onPressed: _isLoading ? null : _sendMessage, icon: Icon(Icons.send, color: Colors.black)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
