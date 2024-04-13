from fastapi import FastAPI, Request
import json
from Backend.Text import *
from Backend.text_to_speech import audio
import re
app = FastAPI()

@app.get("")
def index(request: Request):
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

