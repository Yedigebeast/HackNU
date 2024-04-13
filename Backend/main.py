from fastapi import FastAPI, Request, Query
from fastapi.responses import RedirectResponse
import json
from Backend.text_to_speech import audio
import re
from Backend.Text import *
from Backend.User import *
from Backend.CallRequest import *

app = FastAPI()

@app.get("")
def index(request: Request):
    return "works"


@app.get("/reading/text")
def reading_words_list():
    return {"words_list": text_to_words()}

@app.get("/listening/audio")
def listening(request: Request):
    audio_result = audio() or ("default text", "default audio_url")
    text, audio_url = audio_result
    print(f"FuncText: {text}, {audio_url}")
    return {"text": text, "audio": audio_url}



print(print_db())


@app.get("/users")
def users_list():
    return {"users_list": get_users()}

@app.get("/sign")
def login(email: str = None, password: str = None):
    if find_user(email=email, password=password):
        return True
    else:
        return RedirectResponse(url="/register")

@app.post("/register")
def register(email: str, password: str):
    if not find_user(email=email, password=password):
        add_user(email=email, password=password)

@app.post("/request/{user_email}/{interest_id}")
def create_request():
    user = find_user(email=user_email)
    interest = find_interest(id=interest_id)
    add_request(user=user, interest=interest)