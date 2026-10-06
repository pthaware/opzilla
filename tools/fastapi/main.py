from fastapi import FastAPI
import httpx
import socket
import os

app = FastAPI()


def get_host_ip():
    return socket.gethostbyname(socket.gethostname())


@app.get("/")
def home():
    return {
        "message": "FastAPI app is running",
        "host_ip": get_host_ip(),
        "port": os.getenv("PORT", "8000")
    }


@app.get("/users")
def users():
    return [
        {"id": 1, "name": "John"},
        {"id": 2, "name": "Alice"},
        {"id": 3, "name": "Bob"}
    ]


@app.get("/posts")
async def posts():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://jsonplaceholder.typicode.com/posts"
        )
    return response.json()


@app.get("/todos")
async def todos():
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://jsonplaceholder.typicode.com/todos"
        )
    return response.json()
