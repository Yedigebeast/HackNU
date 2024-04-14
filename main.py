import os

import uvicorn
from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse
from text_to_speech import audio
from Text import *
from User import *
from CallRequest import *
from meeting import speaking_meeting_link
from words import *
app = FastAPI()


@app.get("/")
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




@app.get("/users")
def users_list():
    return {"users_list": get_users()}


@app.get("/sign")
def login(email: str = None, password: str = None):
    if find_user(email=email):
        return True
    else:
        return RedirectResponse(url="/register")


@app.post("/register")
def register(email: str, password: str):
    if not find_user(email=email, password=password):
        add_user(email=email, password=password)


@app.post("/request/{user_email}/{interest_id}")
def create_request():
    if not find_user(email=email):
        user = add_user(email=email, password=password)
        return {'user': user}


@app.get("/interest/{name}")
def create_interest(name: str):
    interest = add_interest(name=name)
    return {'interest': interest.name}


@app.get("/request/{user_email}/{interest_id}")
def create_request(user_email: str, interest_id: int):
    user = find_user(email=user_email)
    interest = find_interest(id=interest_id)
    add_request(user=user, interest=interest)


@app.get("/speaking/gogo")
def speaking():
    return {"meeting_link": speaking_meeting_link()}

@app.get("/dictionary/item")
def dict_item():
    new_item = get_random_word()
    return {"word": new_item.word, "rus": new_item.rus, "eng": new_item.eng, "description": new_item.desc}
print("WORDS\n\n")
# print_db_words()
print((get_random_word().word))
if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=os.getenv("PORT", default=8000), log_level="info")
