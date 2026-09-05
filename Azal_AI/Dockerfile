FROM python:3.10-slim

# تثبيت الأدوات الضرورية
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# نسخ وتثبيت المتطلبات
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# نسخ كل ملفات المشروع
COPY . .

# استخدام متغير البيئة PORT اللي توفره Render (أو 8000 كاحتياط)
ENV PORT=8000
EXPOSE 8000

# تشغيل السيرفر
CMD ["python", "main.py"]
