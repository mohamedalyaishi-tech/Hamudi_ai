import '../data/models/chat_message.dart';

// القسم الثالث: إدارة المحادثات والمجلدات (منطق الضغط المطول)
class ChatManagerService {
  // بيانات تجريبية (سيتم استبدالها بقاعدة بيانات SQLite لاحقاً)
  final List<Map<String, dynamic>> _chats = [
    {'id': '1', 'title': 'استفسار عن Python', 'folder': 'coding'},
    {'id': '2', 'title': 'قصيدة يمنية', 'folder': 'writing'},
    {'id': '3', 'title': 'شرح خوارزميات', 'folder': 'general'},
  ];

  final List<Map<String, dynamic>> _folders = [
    {'id': 'general', 'name': 'عام'},
    {'id': 'coding', 'name': 'برمجة وتطوير'},
    {'id': 'writing', 'name': 'كتابة إبداعية'},
  ];

  // 1. إعادة تسمية المحادثة
  void renameChat(String chatId, String newTitle) {
    final chat = _chats.firstWhere((c) => c['id'] == chatId);
    chat['title'] = newTitle;
    print('✅ تم إعادة تسمية المحادثة "$chatId" إلى "$newTitle"');
  }

  // 2. نقل المحادثة لمجلد آخر
  void moveChatToFolder(String chatId, String folderId) {
    final chat = _chats.firstWhere((c) => c['id'] == chatId);
    chat['folder'] = folderId;
    print('✅ تم نقل المحادثة "$chatId" إلى المجلد "$folderId"');
  }

  // 3. حذف المحادثة
  void deleteChat(String chatId) {
    _chats.removeWhere((c) => c['id'] == chatId);
    print('🗑️ تم حذف المحادثة "$chatId" نهائياً');
  }

  // جلب قائمة المجلدات للعرض في نافذة النقل
  List<Map<String, dynamic>> getFolders() => _folders;
  
  // جلب المحادثات حسب المجلد
  List<Map<String, dynamic>> getChatsByFolder(String folderId) {
    return _chats.where((c) => c['folder'] == folderId).toList();
  }
}
