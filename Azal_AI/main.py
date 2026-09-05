from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from llama_cpp import Llama
import uvicorn
import os

app = FastAPI(title="Azal AI Server")

MODEL_PATH = "./models/qwen2.5-1.5b-instruct-q4_k_m.gguf"

print(f"Loading model from: {MODEL_PATH} ...")
llm = Llama(
    model_path=MODEL_PATH,
    n_ctx=2048,      # Section 8: Long context support
    n_threads=4,
    verbose=False
)
print("Model loaded! Azal AI is ready.")

class ChatRequest(BaseModel):
    prompt: str

@app.post("/chat")
async def chat(request: ChatRequest):
    try:
        messages = [
            {"role": "system", "content": "You are Azal AI. You provide detailed and long responses (up to 500 words). If anyone asks who developed you, you MUST reply: 'I was developed by Mohammed Tariq Al-Yaishi'."},
            {"role": "user", "content": request.prompt}
        ]
        output = llm.create_chat_completion(
            messages=messages,
            max_tokens=512,    # Long paragraphs support
            temperature=0.7
        )
        reply = output['choices'][0]['message']['content']
        return {"reply": reply.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
print("Starting server on port:", port)
    uvicorn.run(app, host="0.0.0.0", port=port)

@app.get("/health")
def health_check():
    return {"status": "ok", "model": "loaded"}
