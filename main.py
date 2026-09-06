import os
import httpx
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

# المفتاح الجديد والمحدث
GROQ_API_KEY = "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"
GROQ_MODEL = "qwen/qwen3.8-27b"
GROQ_URL = "https://api.groq.com/openai/v1/chat/completions"

class ChatRequest(BaseModel):
    message: str

@app.get("/health")
def health_check():
    return {"status": "ok", "model": GROQ_MODEL}

@app.post("/chat")
async def chat(request: ChatRequest):
    if not GROQ_API_KEY:
        raise HTTPException(status_code=500, detail="Groq API Key missing")

    async with httpx.AsyncClient() as client:
        response = await client.post(
            GROQ_URL,
            headers={"Authorization": f"Bearer {GROQ_API_KEY}", "Content-Type": "application/json"},
            json={
                "model": GROQ_MODEL,
                "messages": [
                    # هنا تم تعديل رد المطور كما طلبت
                    {"role": "system", "content": "أنت أزال AI، مساعد ذكي ومتخصص. تم تطويرك بواسطة محمد طارق اليعيشي."},
                    {"role": "user", "content": request.message}
                ],
                "temperature": 0.7,
                "max_tokens": 1024
            }
        )

    if response.status_code == 200:
        return {"reply": response.json()["choices"][0]["message"]["content"]}
    else:
        return {"error": response.text}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))
