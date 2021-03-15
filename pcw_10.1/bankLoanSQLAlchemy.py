import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Numeric
from sqlalchemy.orm import relationship, sessionmaker 
from sqlalchemy.orm import sessionmaker 
from sqlalchemy.ext.declarative import declarative_base
'''
1. Rewrite all the CREATE TABLE commands for the Clients and Loans 
tables to now use SQLAlchemy. The SQLAlchemy commands should also 
create primary key and foreign key constraints where appropriate.
'''

engine = create_engine('sqlite:///:memory:', echo=True)
engine.connect() #connect to engine interface
# declare a base
Base = declarative_base()

#-- create a table mapping
class Client(Base):
    __tablename__ = 'clients'
    client_number = Column(Integer, unique=True, nullable=False, primary_key=True)
    first_name = Column(String)
    surname = Column(String)
    email = Column(String)
    phone = Column(String)
    # loans = relationship('Loan') # one client can have many loans
    def __repr__(self):
        return 'Client(client_number={}, fn={}, sn={}, email={}, phone={}'.format(self.client_number, self.first_name, self.surname, self.email, self.phone)

class Loan(Base):
    __tablename__ = 'loans'
    account_number = Column(Integer,unique=True, nullable=False, primary_key=True)
    client_number = Column(Integer, ForeignKey('clients.client_number'), unique=True)
    start_date = Column(DateTime)
    start_month = Column(DateTime)
    term = Column(Integer)
    remaining_term = Column(Integer)
    principal_debt = Column(Numeric(11,2))
    account_limit = Column(Numeric(11,2))
    balance = Column(Numeric(11, 2))
    status = Column(String)
    clients = relationship('Client')

    def __repr__(self):
        return 'Loan(account_number={1}, client_number={2}, start_date={3}, start_month={4}, term={5}, remaining_term={},principal_debt={}, account_limit={},balance={}, status={}'.format(self.account_number, 
        self.client_number, self.start_date, self.start_month, self.term, self.remaining_term, self.principal_debt, 
        self.account_limit, self.balance, self.status)

Base.metadata.create_all(engine) # without this, schema is not initialized 

'''
2. Rewrite an INSERT command to now use SQLAlchemy. 
In particular, you should hold all the values in a 
standard Python container (e.g. list, dictionary, or namedtuple), 
or a combination of Python containers (e.g. list of dictionaries). 
The insertions should all happen in a single transaction.
'''

client1 = Client(client_number=1, first_name='Robert', surname='Warren', email='RobertDWarren@teleworm.us', phone='(251) 546-9442')
client2 = Client(client_number=2, first_name='Vincent', surname='Brown', email='VincentHBrown@rhyta.com', phone='(125) 546-4478')
client3 = Client(client_number=3, first_name='Janet', surname='Prettyman', email='JanetTPrettyman@teleworm.us', phone= '(949) 569-4371')
client4 = Client(client_number=4, first_name='Martina', surname='Kershner', email='MartinaMKershner@rhyta.com', phone='(630) 446-8851')
client5 = Client(client_number=5, first_name='Tony', surname='Schroeder', email='TonySSchroeder@teleworm.us', phone='(226) 906-2721')
client6 = Client(client_number=6, first_name='Harold', surname='Grimes', email='HaroldVGrimes@dayrep.com', phone='(671) 925-1352')

Session = sessionmaker(bind=engine)
session = Session()
session.add_all([client1, client2, client3, client4, client5, client6])

session.commit() # user should now be in db!
# print(session.query(Client).filter_by(client_number=1).first())

'''
Rewrite a SELECT query and an UPDATE command to now use SQLAlchemy.
SELECT FIRSTNAME, SURNAME, BALANCE FROM Loans
    JOIN Clients ON Loans.CLIENTNUMBER = Clients.CLIENTNUMBER
    WHERE BALANCE > 5000.00;
'''
# print('First client select', session.query(Client).filter_by(client_number=1).first())
# print('hah', session.query(Client, Loan).filter(Loan.balance>5000.00))
for c, i in session.query(Customer, Invoice).filter(Customer.id == Invoice.custid).all():


## UPDATE
q = session.query(Client).filter_by(client_number=2).first()
q.first_name = 'Jackie'
session.commit()
print(session.query(Client).filter_by(client_number=2).first())

