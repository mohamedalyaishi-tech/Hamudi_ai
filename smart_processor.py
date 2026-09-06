import re

class SmartProcessor:
    """المحرك الذكي لمعالجة النصوص الضخمة"""
    def __init__(self, max_tokens_per_chunk=400):
        self.max_tokens = max_tokens_per_chunk

    def is_large_request(self, text: str) -> bool:
        """كشف حجم الطلب تلقائياً"""
        return (len(text) / 4) > self.max_tokens

    def semantic_chunking(self, text: str) -> list[str]:
        """التقسيم الدلالي الذكي (يحترم الجمل والفقرات)"""
        if not self.is_large_request(text):
            return [text]
            
        chunks = []
        sentences = re.split(r'(?<=[.!?؟\n])\s+', text)
        current_chunk = ""
        
        for sentence in sentences:
            if len(current_chunk) + len(sentence) < self.max_tokens * 4:
                current_chunk += sentence + " "
            else:
                if current_chunk: chunks.append(current_chunk.strip())
                current_chunk = sentence + " "
                
        if current_chunk: chunks.append(current_chunk.strip())
        return chunks
