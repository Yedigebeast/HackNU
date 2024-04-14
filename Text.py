from sqlalchemy import Column, String, Integer
import requests, random
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Text(Base):
    __tablename__ = "texts"
    id = Column("id", Integer, primary_key=True, autoincrement=True)
    text = Column("text", String)

    def __init__(self, text):
        self.text = text


    # def __repr__(self):
    #     return f"{self.title} {self.content} {self.category} {self.image} {self.url}"

engine = create_engine("sqlite:///texts.db")
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()


def add_text_DB(text: str):
    existing_text = session.query(Text).filter_by(text=text).first()
    if existing_text is None:
        new_text = Text(text)
        session.add(new_text)
        session.commit()
        return True
    else:
        return False


def print_db():
    all_elements = session.query(Text).all()
    for element in all_elements:
        print(element.text)


def text_to_words():
    random_text = get_random_text()
    return random_text.split()


def get_random_text():
    return random.choice(session.query(Text).all()).text


def delete_db():
    session.query(Text).delete()
    session.commit()
