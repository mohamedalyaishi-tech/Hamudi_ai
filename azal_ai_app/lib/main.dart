import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AzalAIApp());
}

class AzalAIApp extends StatelessWidget {
  const AzalAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azal AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF09090b), // أسود فحمي فاخر
        primaryColor: const Color(0xFF7c3aed), // بنفسجي كهربائي
        fontFamily: 'Tajawal',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7c3aed),
          surface: Color(0xFF18181b), // لون البطاقات
          onSurface: Color(0xFFf4f4f5), // نص أبيض مريح
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF27272a),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: Color(0xFF7c3aed))),
          hintStyle: const TextStyle(color: Color(0xFFa1a1aa)),
        ),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'مرحباً بك في أزال AI! أنا هنا لمساعدتك باستخدام ذكاء Qwen الخارق.', 'isUser': false, 'isLoading': false},
  ];
  bool _isTyping = false;

  // رابط سيرفرك الجديد
  static const String apiUrl = "https://txz.onrender.com/chat";

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isTyping) return;
    
    final userMessage = _controller.text;
    _controller.clear();
    
    setState(() {
      _messages.add({'text': userMessage, 'isUser': true});
      _messages.add({'text': '', 'isUser': false, 'isLoading': true});
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": userMessage}),
      ).timeout(const Duration(seconds: 30));

      setState(() {
        _messages.removeLast(); // إزالة مؤشر التحميل
        _isTyping = false;
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          _messages.add({'text': data['reply'] ?? 'عذراً، لم أفهم الرد.', 'isUser': false});
        } else {
          _messages.add({'text': 'حدث خطأ في السيرفر. يرجى المحاولة لاحقاً.', 'isUser': false});
        }
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _isTyping = false;
        _messages.add({'text': 'تعذر الاتصال. تأكد من أن السيرفر مستيقظ (قد يستغرق بضع ثوانٍ).', 'isUser': false});
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أزال AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                return _buildBubble(msg);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF09090b).withValues(alpha: 0.95),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 15, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Color(0xFFf4f4f5), fontSize: 16),
                    decoration: const InputDecoration(hintText: 'اسأل أزال أي شيء...', contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: _isTyping ? const Color(0xFF4c1d95) : const Color(0xFF7c3aed),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFF7c3aed).withValues(alpha: 0.4), blurRadius: 10)],
                  ),
                  child: IconButton(
                    icon: _isTyping ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _isTyping ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final isUser = msg['isUser'] as bool;
    final isLoading = msg['isLoading'] as bool? ?? false;
    
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF7c3aed) : const Color(0xFF27272a),
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
          ),
          boxShadow: isUser ? [BoxShadow(color: const Color(0xFF7c3aed).withValues(alpha: 0.3), blurRadius: 12)] : null,
        ),
        child: isLoading 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFFa78bfa), strokeWidth: 2))
          : Text(msg['text'], style: TextStyle(color: isUser ? Colors.white : const Color(0xFFf4f4f5), fontSize: 16, height: 1.5), textAlign: isUser ? TextAlign.right : TextAlign.left),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
