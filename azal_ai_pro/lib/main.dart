import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const Color kBg = Color(0xFF050505);
const Color kPri = Color(0xFF7C4DFF);
const Color kSec = Color(0xFFB388FF);
const Color kUsr = Color(0xFF6200EA);
const Color kBot = Color(0xFF1E1E1E);

void main() => runApp(const AzalApp());

class AzalApp extends StatelessWidget {
  const AzalApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azal AI Pro',
      theme: ThemeData(
        scaffoldBackgroundColor: kBg,
        primaryColor: kPri,
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(primary: kPri),
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatController extends GetxController {
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();
  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final String apiUrl = "https://azal-ai-5txz.onrender.com/chat";

  Future<void> send() async {
    String txt = msgCtrl.text.trim();
    if (txt.isEmpty) return;
    messages.add({'text': txt, 'isUser': true});
    msgCtrl.clear();
    _scrollDown();
    isLoading.value = true;
    try {
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": txt}),
      ).timeout(const Duration(seconds: 30));
      
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        messages.add({'text': data['reply'] ?? "لا يوجد رد", 'isUser': false});
      } else {
        messages.add({'text': "خطأ سيرفر: ${res.statusCode}", 'isUser': false});
      }
    } catch (e) {
      messages.add({'text': "تأكد من الإنترنت", 'isUser': false});
    } finally {
      isLoading.value = false;
      _scrollDown();
    }
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollCtrl.hasClients) {
        scrollCtrl.animateTo(
          scrollCtrl.position.maxScrollExtent, 
          duration: const Duration(milliseconds: 300), 
          curve: Curves.easeOut
        );
      }
    });
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ChatController c = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: Text("أزال AI", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        centerTitle: true, 
        elevation: 0, 
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBg, Color(0xFF1A0B2E)], 
              begin: Alignment.topCenter, 
              end: Alignment.bottomCenter
            )
          )
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              controller: c.scrollCtrl, 
              padding: const EdgeInsets.all(16),
              itemCount: c.messages.length,
              itemBuilder: (ctx, i) {
                final m = c.messages[i];
                return Align(
                  alignment: m['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6), 
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                    decoration: BoxDecoration(
                      color: m['isUser'] ? kUsr : kBot,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20), 
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(m['isUser'] ? 20 : 4), 
                        bottomRight: Radius.circular(m['isUser'] ? 4 : 20)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: m['isUser'] ? kPri.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.2), 
                          blurRadius: 8, 
                          offset: const Offset(0, 4)
                        )
                      ]
                    ),
                    child: Text(m['text'], style: GoogleFonts.cairo(fontSize: 15, color: Colors.white))
                  )
                );
              }
            ))
          ),
          Obx(() => c.isLoading.value 
            ? const Padding(padding: EdgeInsets.all(8), child: SpinKitThreeBounce(color: kSec, size: 20)) 
            : const SizedBox.shrink()
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kBot, 
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10)]
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: c.msgCtrl, 
                    style: GoogleFonts.cairo(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "اسأل أزال...", 
                      hintStyle: GoogleFonts.cairo(color: Colors.grey[600]), 
                      border: InputBorder.none, 
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                    )
                  )
                ),
                GestureDetector(
                  onTap: () => c.send(),
                  child: Container(
                    padding: const EdgeInsets.all(12), 
                    decoration: const BoxDecoration(
                      color: kPri, 
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: kPri, blurRadius: 10, spreadRadius: 2)]
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 22)
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }
}