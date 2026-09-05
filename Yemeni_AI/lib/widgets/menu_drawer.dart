import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../services/chat_manager_service.dart';

// القسم الثالث: القائمة الجانبية مع تفعيل خيارات الضغط المطول
class MenuDrawer extends StatefulWidget {
  final VoidCallback? onNewChat;
  final Function(String folderId)? onSelectFolder;
  
  const MenuDrawer({super.key, this.onNewChat, this.onSelectFolder});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final ChatManagerService _chatManager = ChatManagerService();
  
  // بيانات تجريبية (سيتم استبدالها ببيانات حقيقية من الخدمة لاحقاً)
  List<Map<String, dynamic>> _chats = [
    {'id': '1', 'title': 'استفسار عن Python', 'folder': 'coding', 'time': 'منذ دقيقة'},
    {'id': '2', 'title': 'قصيدة يمنية', 'folder': 'writing', 'time': 'أمس'},
    {'id': '3', 'title': 'شرح خوارزميات', 'folder': 'general', 'time': 'قبل يومين'},
  ];

  void _refreshChats() {
    setState(() {
      // إعادة تحميل القائمة بعد أي عملية تعديل
      _chats = [
        {'id': '1', 'title': 'استفسار عن Python', 'folder': 'coding', 'time': 'منذ دقيقة'},
        {'id': '2', 'title': 'قصيدة يمنية', 'folder': 'writing', 'time': 'أمس'},
        {'id': '3', 'title': 'شرح خوارزميات', 'folder': 'general', 'time': 'قبل يومين'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.darkGrey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // رأس القائمة
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              color: AppTheme.deepBlack,
              borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: AppTheme.matteGold, size: 32),
                const SizedBox(width: 12),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    color: AppTheme.matteGold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white12, height: 1),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                // زر محادثة جديدة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onNewChat?.call();
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(AppStrings.newChat, style: TextStyle(fontFamily: 'Cairo')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.matteGold,
                      foregroundColor: AppTheme.deepBlack,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // قسم المجلدات
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('المجلدات', 
                    style: TextStyle(color: AppTheme.softGrey, fontFamily: 'Cairo', fontSize: 13)),
                ),
                const SizedBox(height: 8),
                ..._chatManager.getFolders().map((folder) => ListTile(
                  leading: Icon(Icons.folder_open, color: AppTheme.matteGold, size: 22),
                  title: Text(folder['name'], style: const TextStyle(color: AppTheme.pureWhite, fontFamily: 'Tajawal')),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onSelectFolder?.call(folder['id']);
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                )),
                
                const Divider(color: Colors.white12, height: 24, indent: 24, endIndent: 24),
                
                // قسم المحادثات الأخيرة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('المحادثات الأخيرة', 
                    style: TextStyle(color: AppTheme.softGrey, fontFamily: 'Cairo', fontSize: 13)),
                ),
                const SizedBox(height: 8),
                ..._chats.map((chat) => GestureDetector(
                  onLongPress: () => _showChatOptions(context, chat),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.matteGold.withOpacity(0.2),
                      child: Icon(Icons.chat_bubble_outline, color: AppTheme.matteGold, size: 20),
                    ),
                    title: Text(chat['title'], style: const TextStyle(color: AppTheme.pureWhite, fontFamily: 'Tajawal', fontSize: 14)),
                    subtitle: Text(chat['time'], style: TextStyle(color: AppTheme.softGrey, fontFamily: 'Tajawal', fontSize: 11)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // قائمة الخيارات عند الضغط المطول - مفعلة بالكامل
  void _showChatOptions(BuildContext context, Map<String, dynamic> chat) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkGrey,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline, color: AppTheme.matteGold),
              title: const Text('إعادة تسمية', style: TextStyle(color: AppTheme.pureWhite, fontFamily: 'Tajawal')),
              onTap: () async {
                Navigator.pop(ctx);
                final controller = TextEditingController(text: chat['title']);
                final newTitle = await showDialog<String>(
                  context: context,
                  builder: (dCtx) => AlertDialog(
                    backgroundColor: AppTheme.darkGrey,
                    title: const Text('إعادة تسمية', style: TextStyle(color: AppTheme.matteGold, fontFamily: 'Cairo')),
                    content: TextField(
                      controller: controller,
                      style: const TextStyle(color: AppTheme.pureWhite),
                      decoration: const InputDecoration(hintText: 'الاسم الجديد'),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text('إلغاء')),
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, controller.text),
                        child: const Text('حفظ', style: TextStyle(color: AppTheme.matteGold)),
                      ),
                    ],
                  ),
                );
                if (newTitle != null && newTitle.isNotEmpty) {
                  _chatManager.renameChat(chat['id'], newTitle);
                  _refreshChats();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open, color: AppTheme.matteGold),
              title: const Text('نقل لمجلد', style: TextStyle(color: AppTheme.pureWhite, fontFamily: 'Tajawal')),
              onTap: () {
                Navigator.pop(ctx);
                _showMoveToFolderDialog(context, chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('حذف المحادثة', style: TextStyle(color: Colors.redAccent, fontFamily: 'Tajawal')),
              onTap: () {
                Navigator.pop(ctx);
                _chatManager.deleteChat(chat['id']);
                _refreshChats();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // نافذة اختيار المجلد للنقل
  void _showMoveToFolderDialog(BuildContext context, Map<String, dynamic> chat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkGrey,
        title: const Text('نقل إلى مجلد', style: TextStyle(color: AppTheme.matteGold, fontFamily: 'Cairo')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _chatManager.getFolders().map((folder) => ListTile(
            title: Text(folder['name'], style: const TextStyle(color: AppTheme.pureWhite)),
            onTap: () {
              _chatManager.moveChatToFolder(chat['id'], folder['id']);
              Navigator.pop(ctx);
              _refreshChats();
            },
          )).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ],
      ),
    );
  }
}
