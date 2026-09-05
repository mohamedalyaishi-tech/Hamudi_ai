import os
import uvicorn
from fastapi import FastAPI

app = FastAPI()

# Health check endpoint (يرد فوراً)
@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/")
def root():
    return {"message": "Azal AI is loading..."}

# تحميل الموديل بعد تشغيل السيرفر
print(">>> Starting server first, then loading model...")
uvicorn.run(app, host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))

# الكود الأصلي لتحميل الموديل (راح نضيفه هنا إذا اشتغل السيرفر)
# لكن الأفضل نستخدم threading عشان ما يوقف السيرفر
