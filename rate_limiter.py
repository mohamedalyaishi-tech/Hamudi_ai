import asyncio
import httpx
from fastapi import HTTPException

async def safe_groq_request(url, headers, payload, max_retries=3):
    """صمام الأمان: إدارة الحدود وإعادة المحاولة الذكية"""
    # إضافة سقف التوكنات إجبارياً
    payload["max_tokens"] = 400 
    
    retries = 0
    while retries < max_retries:
        try:
            async with httpx.AsyncClient() as client:
                response = await client.post(url, headers=headers, json=payload)
                
                if response.status_code == 429 and retries < max_retries - 1:
                    wait_time = 2 * (retries + 1)
                    print(f"⏳ تجاوز الحد، انتظار {wait_time} ثواني...")
                    await asyncio.sleep(wait_time)
                    retries += 1
                    continue
                    
                response.raise_for_status()
                return response.json()
                
        except httpx.HTTPStatusError as e:
            if e.response.status_code == 429:
                raise HTTPException(status_code=503, detail="السيرفر مشغول جداً، يرجى المحاولة بعد دقيقة")
            raise HTTPException(status_code=e.response.status_code, detail=str(e))
        except Exception as e:
            raise HTTPException(status_code=500, detail=f"خطأ غير متوقع: {str(e)}")
