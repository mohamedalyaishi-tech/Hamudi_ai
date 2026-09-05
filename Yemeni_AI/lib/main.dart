import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'screens/chat/chat_screen.dart';
import 'core/constants/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // إعداد شريط الحالة ليكون شفافاً ومتناسقاً مع الخلفية السوداء
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.deepBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const YemeniAIApp());
}

class YemeniAIApp extends StatelessWidget {
  const YemeniAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // ربط الثيم الذهبي والأسود
      home: const ChatScreen(),   // نقطة الانطلاق: شاشة المحادثة
    );
  }
}
