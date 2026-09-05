import '../services/ai_service.dart';
import '../data/models/chat_message.dart';

// القسم الثامن: المعالجة الذكية للطلبات الضخمة
class SmartProcessor {
  final AIService _aiService = AIService();
  static const int MAX_CHUNK_SIZE = 3500; // الحد الأقصى للحروف قبل التقسيم

  // الدالة الرئيسية: معالجة الطلبات الطويلة تلقائياً
  Future<ChatMessage> processRequest(String userMessage, List<ChatMessage> history) async {
    // 1. كشف الحجم: هل النص طويل ويحتاج تقسيم؟
    if (userMessage.length <= MAX_CHUNK_SIZE) {
      return await _aiService.sendMessage(userMessage, history);
    }

    // 2. التقسيم الدلالي (Semantic Chunking): القص عند النقاط والفقرات
    final chunks = _semanticSplit(userMessage);
    print(' تم تقسيم الرسالة الطويلة إلى ${chunks.length} دفعات');

    // 3. معالجة متسلسلة غير متزامنة
    List<String> partialResponses = [];
    for (int i = 0; i < chunks.length; i++) {
      final chunkMsg = i == 0 
        ? userMessage.substring(0, chunks[0].length) // أول دفقة تحتوي السياق الكامل
        : chunks[i];
      
      final response = await _aiService.sendMessage(chunkMsg, history);
      partialResponses.add(response.content);
    }

    // 4. إعادة التجميع الذكي والمتماسك
    final combinedResponse = partialResponses.join('\n\n---\n\n');
    
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: combinedResponse,
      isUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.received,
      latency: null, // زمن الاستجابة الكلي يمكن حسابه لاحقاً
    );
  }

  // خوارزمية التقسيم الدلالي (تحترم بنية النص)
  List<String> _semanticSplit(String text) {
    final chunks = <String>[];
    var currentChunk = '';
    
    // التقسيم عند الفقرات المزدوجة أولاً
    final paragraphs = text.split('\n\n');
    
    for (final para in paragraphs) {
      if ((currentChunk + para).length > MAX_CHUNK_SIZE) {
        if (currentChunk.isNotEmpty) chunks.add(currentChunk.trim());
        
        // إذا كانت الفقرة نفسها أطول من الحد، نقسمها عند الجمل
        if (para.length > MAX_CHUNK_SIZE) {
          final sentences = para.split('. ');
          for (final sentence in sentences) {
            if ((currentChunk + sentence).length > MAX_CHUNK_SIZE) {
              chunks.add(currentChunk.trim() + '.');
              currentChunk = sentence;
            } else {
              currentChunk += (currentChunk.isEmpty ? '' : '. ') + sentence;
            }
          }
        } else {
          currentChunk = para;
        }
      } else {
        currentChunk += (currentChunk.isEmpty ? '' : '\n\n') + para;
      }
    }
    
    if (currentChunk.isNotEmpty) chunks.add(currentChunk.trim());
    return chunks;
  }
}
