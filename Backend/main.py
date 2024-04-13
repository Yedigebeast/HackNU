from fastapi import FastAPI, Request
import json
from Backend.Text import text_to_words

app = FastAPI()

@app.get("")
def index(request: Request):
    pass

@app.get("/reading/text")
def reading_words_list():
    return text_to_words()

print(text_to_words())
# print_db()
# print(text_to_words())
