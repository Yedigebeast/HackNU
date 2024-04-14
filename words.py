from sqlalchemy import Column, String, Integer
import requests, random
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Word(Base):
    __tablename__ = "Words"
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    word = Column("text", String)
    rus = Column("rus", String)
    eng = Column("eng", String)
    desc = Column("desc", String)


    def __init__(self, word, rus, eng, desc):
        self.word = word
        self.rus = rus
        self.eng = eng
        self.desc = desc
    # def __repr__(self):
    #     return f"{self.title} {self.content} {self.category} {self.image} {self.url}"

engine = create_engine("sqlite:///words.db")
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()


def add_word_db(word: str, rus: str, eng: str, desc: str):
    existing_text = session.query(Word).filter_by(word=word).first()
    if existing_text is None:
        new_word = Word(word, rus, eng, desc)
        session.add(new_word)
        session.commit()
        return True
    else:
        return False


def print_db_words():
    all_elements = session.query(Word).all()
    for element in all_elements:
        print(element.word)


def text_to_words():
    random_text = get_random_text()
    return random_text.split()


def get_random_word():
    return random.choice(session.query(Word).all())


def delete_db():
    session.query(Text).delete()
    session.commit()
