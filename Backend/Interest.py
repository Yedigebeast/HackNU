from sqlalchemy import Column, Integer, Sequence, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine, and_
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

class Interest(Base):
    __tablename__ = 'users'
    id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
    name = Column(String())
    def __init__(self, name):
        self.name = name

engine = create_engine("sqlite:///interests.db")
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()

def add_interest(name: str):
    db_interest = Interest(name)
    session.add(db_interest)
    session.commit()

def find_interest(name: str):
    return session.query(Interest).filter_by(name=name).first()

def delete_interest(name: str):
    db_interest = find_interest(name=name)
    if db_interest != None:
        session.delete(db_interest)