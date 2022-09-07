# -*- coding: utf-8 -*-

# import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from starlette.staticfiles import StaticFiles

from models.RestfulModel import *
from routers import ocr
from utils.ImageHelper import *

app = FastAPI(title="Paddle OCR API",
              description="基于 Paddle OCR 和 FastAPI 的自用接口")

app.mount('/static', StaticFiles(directory='static'),
          name='static')  # 添加静态文件, 使无外网环境下可访问swagger

# 跨域设置
origins = [
    "*"
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

app.include_router(ocr.router)

# uvicorn.run(app=app, host="0.0.0.0", port=8000, debug=True)
