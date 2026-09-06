import os
import httpx
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

GROQ_API_KEY = "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"
GROQ_MODEL = "qwen2.5-72b-instruct"
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"

# طباعة للتأكد إن المفتاح تم تحميله (راح تظهر في لوجات Render)
print(f"DEBUG: API Key loaded: {GROQ_API_KEY[:10]}...")

class ChatRequest(BaseModel):
    message: str

@app.get("/health")
def health_check():
    return {"status": "ok", "model": GROQ_MODEL}

@app.post("/chat")
async def chat(request: ChatRequest):
    print(f"DEBUG: Received request for message: {request.message}")
    
    if not GROQ_API_KEY:
        raise HTTPException(status_code=500, detail="Groq API Key missing")

    async with httpx.AsyncClient() as client:
        response = await client.post(
            GROQ_URL,
            headers={"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"},
            json={
                "model": GROQ_MODEL,
                "messages": [
                    {"role": "system", "content": "أنت أزال AI، مساعد ذكي ومتخصص."},
                    {"role": "user", "content": request.message}
                ],
                "temperature": 0.7,
                "max_tokens": 1024
            }
        )
        
    print(f"DEBUG: Groq Response Status: {response.status_code}")

    if response.status_code == 200:
        return {"reply": response.json()["choices"][0]["message"]["content"]}
    else:
        # إرجاع تفاصيل الخطأ من Groq لنا
        return {"error": response.text}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))
