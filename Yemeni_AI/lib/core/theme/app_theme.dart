import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // 1. لوحة الألوان البسيطة والفاخرة
  static const Color deepBlack = Color(0xFF050505);      // خلفية سوداء عميقة
  static const Color pureWhite = Color(0xFFFFFFFF);      // نصوص بيضاء نقية
  static const Color matteGold = Color(0xFFD4AF37);      // ذهبي مطفي (بدون لمعة زائدة)
  static const Color darkGrey = Color(0xFF1A1A1A);       // رمادي داكن للعناصر الثانوية
  static const Color softGrey = Color(0xFF888888);       // رمادي فاتح للنصوص الفرعية

  // 2. الثيم الرئيسي للتطبيق
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: deepBlack,
        primaryColor: matteGold,
        
        // إعدادات شريط العنوان (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: deepBlack,
          elevation: 0, // بدون ظل للحفاظ على البساطة
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: matteGold,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
          iconTheme: IconThemeData(color: matteGold),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),

        // إعدادات النصوص والخطوط
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: pureWhite, fontFamily: 'Tajawal', fontSize: 16),
          bodyMedium: TextStyle(color: softGrey, fontFamily: 'Tajawal', fontSize: 14),
          titleLarge: TextStyle(color: matteGold, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),

        // إعدادات حقول الإدخال (بسيطة وأنيقة)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18), // زوايا ناعمة
            borderSide: BorderSide.none, // بدون حدود خارجية
          ),
          hintStyle: const TextStyle(color: softGrey, fontFamily: 'Tajawal'),
        ),

        // إعدادات الأزرار (ذهبية مسطحة)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: matteGold,
            foregroundColor: deepBlack,
            textStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0, // بدون ظل
          ),
        ),
      );
}
