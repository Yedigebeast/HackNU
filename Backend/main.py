from fastapi import FastAPI, Request
import json
from Backend.Text import *

app = FastAPI()

@app.get("")
def index(request: Request):
    pass

@app.get("/reading/text")
def reading_words_list():
    return {"words_list": text_to_words()}


print(print_db())
