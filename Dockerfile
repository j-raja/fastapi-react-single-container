FROM node:16 AS ReactBuild
WORKDIR /app/frontend
COPY ./frontend/package.json /app/frontend/
RUN npm install
COPY ./frontend ./
RUN npm run build

FROM python:3.8-slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

RUN python3 -m pip install --upgrade pip setuptools wheel 

WORKDIR /app/api

COPY   ./api/requirements.txt /app/api/
RUN pip install -r requirements.txt

COPY ./api ./

COPY --from=ReactBuild ./app/frontend/build/. ./templates/.

WORKDIR /app/api
CMD uvicorn main:app --proxy-headers --host 0.0.0.0 --port 8000