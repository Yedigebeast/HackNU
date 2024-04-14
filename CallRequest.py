from sqlalchemy.orm import relationship
from User import User
from Interest import *

Base = declarative_base()

class CallRequest(Base):
    __tablename__ = 'call_requests'
    id = Column(Integer, Sequence('user_id_seq'), primary_key=True)
    user = relationship("User")
    interest = relationship("Interest")
    def __init__(self, user, interest):
        self.user = user
        self.interest = interest


engine = create_engine("sqlite:///users.db")
Base.metadata.create_all(bind=engine)
Session = sessionmaker(bind=engine)
session = Session()

def add_request(user: User, interest: Interest):
    db_call_request = CallRequest(user=user, interest=interest)
    db_second_request = find_request(interest=interest)
    if db_second_request != None:
        link = create_event_link(datetime.now(), datetime.now())
    if db_second_request is not None:
        uuid1 = uuid.uuid1()
        link = "https://usually.in/{uuid}".format(uuid=uuid1)
        send_email(senderEmail=User.email, receiverEmail=db_second_request.user.email, link=link)
        delete_request(db_second_request)
    else:
        session.add(db_call_request)
        session.commit()

def find_request(interest: Interest):
    db_request = session.query(CallRequest).filter_by(interest=interest).first()
    return db_request


def delete_request(db_request: CallRequest):
    session.delete(db_request)
