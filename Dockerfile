FROM python:3.7

# 设置当前目录为工作目录
WORKDIR ./

ADD . .

# apt-get换源并安装依赖
RUN sed -i "s@http://deb.debian.org@http://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libgl1

# pip换源并安装python依赖
RUN python3 -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade pip
RUN pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip3 install -r requirements.txt

# 将 swagger 页面请求改为静态文件
RUN sed -i 's/https:\/\/cdn.jsdelivr.net\/npm\/swagger-ui-dist@4\/swagger-ui-bundle.js/\/static\/swagger-ui\/swagger-ui-bundle.js/g' /usr/local/lib/python3.7/site-packages/fastapi/openapi/docs.py
RUN sed -i 's/https:\/\/cdn.jsdelivr.net\/npm\/swagger-ui-dist@4\/swagger-ui.css/\/static\/swagger-ui\/swagger-ui.css/g' /usr/local/lib/python3.7/site-packages/fastapi/openapi/docs.py
RUN sed -i 's/https:\/\/fastapi.tiangolo.com\/img\/favicon.png/\/static\/swagger-ui\/favicon-32x32.png/g' /usr/local/lib/python3.7/site-packages/fastapi/openapi/docs.py

# CMD ["python3", "./main.py"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]
