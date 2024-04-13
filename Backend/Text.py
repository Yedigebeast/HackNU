from sqlalchemy import create_engine, Column, String, Integer, func
from sqlalchemy.orm import sessionmaker
from sqlalchemy.engine import reflection
from sqlalchemy.ext.declarative import declarative_base
from fastapi import Depends
from pydantic import BaseModel
import string
import random

Base = declarative_base()


class Text(Base):
    __tablename__ = "text"
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    text = Column("text", String)

    def __init__(self, text):
        self.text = text


engine = create_engine("sqlite:///texts.db", echo=True)
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()


def get_db_session():
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db_session = SessionLocal()
    try:
        yield db_session
    finally:
        db_session.close()

def add_text(text: str):
    if len(text) > 10:  # otherwise too short
        existing_text = session.query(Text).filter_by(text=text).first()
        if existing_text is None:
            new_text = Text(text)
            session.add(new_text)
            session.commit()
            return True
        else:
            return False
    return False


def text_to_words(db_session: Session = Depends(get_db_session)):
    random_text_obj = db_session.query(Text).all()
    return random_text_obj
    # if random_text_obj:
    #     words = random_text_obj.text.split()
    #     return words
    # else:
    #     print("Empty\n")
    #     print(random_text_obj)
    #     return None


def print_db():
    all_elements = session.query(Text).all()
    for element in all_elements:
        print(element.text)

def delete_db():
    session.query(Text).delete()
    session.commit()
    # only_words =
# def add_advertisement(user, data: Addd):
#     ad = Advertisement(user, data.type, data.price, data.address, data.area, data.rooms_count, data.description)
#     session.add(ad)
#     session.commit()
#     return ad.id
# Бауырсақ
