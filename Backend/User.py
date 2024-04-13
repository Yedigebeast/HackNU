from sqlalchemy import Column, Integer, Sequence, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine, and_
from sqlalchemy.orm import sessionmaker

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
    first_name = Column(String(100))
    last_name = Column(String(100))
    email = Column(String(100))
    password = Column(String(100))
    def __init__(self, email, password, first_name=None, last_name=None):
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.password = password

engine = create_engine("sqlite:///users.db")
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()

def add_user(email: str, password: str, first_name: str = None, last_name: str = None):
    # some precautionary checks
    db_user = User(first_name=first_name, last_name=last_name, email=email, password=password)
    session.add(db_user)
    session.commit()

def find_user(email: str):
    print(email, password)
    query = "SELECT * FROM users WHERE email = :email AND password = :password, {'email': email, 'password': password}"
    result = session.execute(query, {'email': email, 'password': password})
    if res is not None:
        return True
    else:
        return False

def get_users():
    users = session.query(User).all()
    for user in users:
        print(user.first_name, user.last_name)

def delete_user(email: str):
    deleted_user = session.query(User).filter(User.email==email).first()
    session.delete(user)
    session.commit()

