import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

// القسم السادس: ميزة النسخ الذكي مع الإشعار الأنيق
class SmartCopyOverlay {
  static void show(BuildContext context, String text, Offset position) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy - 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.matteGold,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8)],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.black, size: 18),
                const SizedBox(width: 8),
                const Text('تم النسخ', style: TextStyle(color: Colors.black, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Clipboard.setData(ClipboardData(text: text));
    
    // إخفاء الإشعار بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}
