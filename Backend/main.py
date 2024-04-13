from fastapi import FastAPI, Request, Query
from fastapi.responses import RedirectResponse
import json
from Backend.Text import *
from Backend.text_to_speech import audio
import re
from Backend.Text import *
from Backend.User import *

app = FastAPI()

@app.get("")
def index(request: Request):
    return "works"
    pass


@app.get("/reading/text")
def reading_words_list():
    return {"words_list": text_to_words()}

@app.get("/listening/audio")
def listening(request: Request):
    audio_result = audio() or ("default text", "default audio_url")
    text, audio_url = audio_result
    text_encoded = text.encode('utf-8').decode('utf-8')
    print(f"FuncText: {text_encoded}, {audio_url}")
    return {"text": text_encoded, "audio": audio_url}



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
    pass

@app.post("/register")
def register(email: str, password: str):
    if not find_user(email=email, password=password):
        add_user(email=email, password=password)
    pass
