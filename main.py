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

print_db()
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
add_word_db("ай", "луна", "moon", "Ай — Жердің табиғи серігі, өзінен жарық шығармайтын Жерге ең жақын аспан денесі.")
add_word_db("көктем", "весна", "spring", "Көктем – жыл мезгілдерінің бірі. Көктем наурыз, сәуір, мамыр айларын қамтиды.")
add_word_db("қыс", "зима", "winter", "Қыс — жыл мезгілі, әр аумақтағы ауа температурасы ең төмен болатын климаттық маусым.")
add_word_db("жаз", "лето", "summer", "Жаз — жылдың төрт мезгілінің бірі. Бұл кезде Жер шары өз орбитасының жазғы күн тоқырау нүктесінен күн мен түннің күзгі теңелу нүктесіне дейінгі аралығында болады.")
add_word_db("күз", "осень", "autumn", "Күз – жылдың төрт мезгілінің бірі. Бұл мезгілде Жер шары өз орбитасының күн мен түннің күзгі теңелу нүктесінен Күннің қысқы тоқырау нүктесіне дейінгі аралығында болады.")
add_word_db("ауа райы", "прогноз погоды", "weather forecast", "Ауа райы — атмосфераның жергілікті жердегі белгілі бір уақытта немесе уақыт аралығында (тәулік, ай) байқалатын құбылмалы жағдайы.")
add_word_db("қасқыр", "волк", "wolf", "Қасқыр — жыртқыш аң.")
add_word_db("арыстан", "лев", "lion", "арыстан — жыртқыш аң.")
add_word_db("жолбарыс", "тигр", "tiger", "жолбарыс — жыртқыш аң.")
add_word_db("шұлық", "носки", "socks", "Шұлық - аяқтың төменгі бөлігіне киілетін, тізеге дейін жетпейтін қысқа киім түрі.")
add_word_db("мұғалім", "учитель", "teacher", "Мұғалім немесе оқытушы — болашақ ұрпақты қоғамдық өмірге тез әрі жеңіл қосылу үшін және сол қоғамның мақсаттарын орындайтын адамдармен қамтамасыз ету қабілетін арттыру үшін тәрбиелеу мен оқыту қажеттілігі себебінен әлемдегі ең кең тараған мамандықтардың бірі.")
add_word_db("ғалым", "Учёный", "scientist", "Ғалым деп ғылыми методтар арқылы адамзат білімін жетілдіру мен молайтуға үлес қосқан адамды айтамыз.")
add_word_db("үй", "дом", "house", "Үй — бірнеше мағынадан тұратын сөз. 1) адам тұратын баспана, ғимарат.белгілі бір қоғамдық қажеттілік 2)үшін пайдаланылатын орын, мекеме. Дәстүрлі қазақ қоғамында үйге тән мүлік, тұрмысқа қажетті шаруашылық “үй-жай” деп те атала береді. Үй баспана ретінде адамзат тарихында тас дәуірінен бастап белгілі.")
add_word_db("шатыр", "крыша", "roof", "Шатыр — далалық жағдайларда жеке құрамды, әскери техниканы, медициналық мекемелерді, шеберханаларды және қоймаларды орналастыруға арналған жиналмалы құрылыс.")
print_db_words()

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=os.getenv("PORT", default=8000), log_level="info")
