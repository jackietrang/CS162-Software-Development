import sqlalchemy
from sqlalchemy import create_engine 
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.orm import sessionmaker # add instance to DB by starting a session

engine = create_engine('sqlite:///:memory:', echo=True) # init a sqlite db
#-- connect to the engine interface
engine.connect()
#-- declare a base
from sqlalchemy.ext.declarative import declarative_base 
Base = declarative_base()

#-- create a table mapping
class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key = True)
    name = Column(String)
    insurance_id = Column(Integer)

    def __repr__(self):
        return "<User(id={0}, name={1}, insurance_id={2})>".format(self.id, self.name, self.insurance_id)

class Insurance(Base):
    __tablename__ = 'insurance'
    id = Column(Integer, ForeignKey('users.insurance_id'), primary_key = True)
    claim_id = Column(Integer)
    users = relationship(User)

#-- after defining the schema of the table we need to create it in db
Base.metadata.create_all(engine) # without this, schema is not initialized 

#-- add elements to table
# create an instance of User class
user = User(id=1, name='sterne', insurance_id=1234)
user2 = User(id=2, name='cs', insurance_id=000)

Session = sessionmaker(bind=engine)
session = Session()
session.add(user)
session.add(user2)

session.commit() # user should now be in db!

#-- Query table
# check if user is in db
print(session.query(User))

# -- Reflect an existing database with SQLAlchemy
## reflect a table = read its metadata, user SQLAlchemy to read the contents of table
from sqlalchemy import Table, MetaData 
metadata = MetaData()
# load table 'users' before with above function
# autoload_with=engine --> ensure connect to the right engine interface
users = Table('users', metadata, autoload=True, autoload_with=engine)
# print repr method defined in User(Base)
print(repr(users))