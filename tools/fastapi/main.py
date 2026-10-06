from fastapi import FastAPI, HTTPException
import httpx

app = FastAPI(title="Simple FastAPI App")


# -------------------------
# Home
# -------------------------
@app.get("/")
def home():
    return {
        "message": "FastAPI app is running"
    }


# -------------------------
# Get Users
# -------------------------
@app.get("/users")
def get_users():
    return [
        {"id": 1, "name": "John"},
        {"id": 2, "name": "Alice"},
        {"id": 3, "name": "Bob"}
    ]


# -------------------------
# Get Posts
# -------------------------
@app.get("/posts")
async def get_posts():
    url = "https://jsonplaceholder.typicode.com/posts"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=500,detail="Failed to get posts")
    return response.json()


# -------------------------
# Get Todos
# -------------------------
@app.get("/todos")
async def get_todos():
    url = "https://jsonplaceholder.typicode.com/todos"
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
    if response.status_code != 200:
        raise HTTPException(status_code=500,detail="Failed to get todos")
    return response.json()