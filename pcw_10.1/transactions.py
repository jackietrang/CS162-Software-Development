# Any necessary installs/imports
import sqlalchemy
from sqlalchemy import create_engine 
from sqlalchemy import Column, Integer, String, ForeignKey, Numeric
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy.ext.declarative import declarative_base 
engine = create_engine('sqlite:///table9.db', echo = True)
engine.connect()
Base = declarative_base()

# Create the tables
class Balances(Base):
    __tablename__ = "balances"
    account_id = Column(Integer,  primary_key = True) 
    Name = Column(String)
    Balance= Column(Numeric(10,2)) # not sure abt insights
    
class Payments(Base):
    __tablename__='payments'
    PaymentID = Column(Integer, primary_key=True)
    from_account_id = Column(Integer, ForeignKey('balances.account_id'))
    to_account_id = Column(Integer, ForeignKey('balances.account_id'))
    Amount = Column(Numeric(10,2))
    
    from_account = relationship("Balances", foreign_keys=[from_account_id])
    to_account = relationship("Balances", foreign_keys=[to_account_id])
                       
Base.metadata.create_all(engine)    
from sqlalchemy.orm import sessionmaker  
Session = sessionmaker(bind=engine)
session = Session() 
      
# Do the inserts
print("---beginning inserts")
session.add_all([Balances(account_id =101, Name ="Chad E. Blair", Balance = 100.00),
                Balances(account_id =102, Name ="Michael K. Taylor",Balance = 0.00)])
session.commit()
 # Do the transaction
try: 
    print('-- starting a transaction')
    # first query
    q1 = session.query(Balances).filter_by(AccountID =101).first()
    q1.Balance  -= 100
    q2 = session.query(Balances).filter_by(AccountID =102).first()
    q2.Balance += 100                   
    session.commit()
    print('--finished')
except: 
    session.rollback()
    raise         #raise any exceptions          
                       
                      
# Fetch everything from both tables


'''
Different way to do it
#session.add                                              
balances = [
    {"account_ID": 101,
     "name": "Chad E. Blair",
     "balance": 100.00},
    {"account_ID": 101,
     "name": "Michael K. Taylor",
     "balance": 0.00}
]
  
for balance in balances:
	balance_ = Balances(
		account_ID=balance['account_ID'], 
		name=balance['name'], 
		balance=balance['balance']
	)
	session.add(balance_)
	session.commit()    

'''