import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Numeric,ForeignKeyConstraint, UniqueConstraint
from sqlalchemy.orm import relationship, sessionmaker 
from sqlalchemy.orm import sessionmaker 
from sqlalchemy.ext.declarative import declarative_base

'''
Online retailer
From the session on transactions:

Rewrite all the CREATE TABLE commands for the tables contained in retail.sql to now use SQLAlchemy. The SQLAlchemy commands should also create primary key and foreign key constraints where appropriate.
Rewrite all the INSERT commands to now use SQLAlchemy. In particular, you should hold all the values in a standard Python container (e.g. list, dictionary, or namedtuple), or a combination of Python containers (e.g. list of dictionaries). The insertions should all happen in a single transaction.
Rewrite all your transactions from the exercise to now use SQLAlchemy.
(Optional) Get SQLAlchemy to output the real SQL commands that it sends to SQLite (this is shown in the recommended tutorial on SQLAlchemy). How do these commands compare with the SQL that you wrote manually? Identify any differences, and find out why SQLAlchemy has done it differently.
'''
engine = create_engine('sqlite:///:memory:', echo=True)
engine.connect()
Base = declarative_base()

# -- create table mapping
class Product(Base):
    __tablename__ = 'products'
    product_id = Column(Integer, primary_key=True)
    title = Column(String)
    description = Column(String) 
    price = Column(Numeric(11,2))
    cost = Column(Numeric(11,2))
    # oder_item = relationship('OrderItem')
class Order(Base):
    __tablename__ = 'orders'
    order_id = Column(Integer, primary_key=True)
    customer_id = Column(Integer)
    date_ordered = Column(DateTime)
    month_ordered = Column(Integer)
    # order_item = relationship('OrderItem')

class OrderItem(Base):
    __tablename__='orderitems'
    order_id = Column(Integer, ForeignKey('orders.order_id'), primary_key=True)
    product_id = Column(Integer, ForeignKey('products.product_id'), primary_key=True)
    quantity = Column(Integer)
    # orders = relationship('Order')
    # products = relationship('Product')
    # __table_args__ = (ForeignKeyConstraint([order_id, product_id]),)
    # __table_args__ = (
    #     UniqueConstraint("order_id", "product_id"), 
    # )


# db.PrimaryKeyConstraint(application_essay_id , application_essay_id )

Base.metadata.create_all(engine)

'''
2. Insert entries
'''

product1 = Product(product_id=3001, title="Widget", description="Widge all your worries away!", price=99.95, cost=23.05)
product2 = Product(product_id=3002, title="Wodget", description="Wodge all your worries away!", price=199.95, cost=123.05)
order_item1 = OrderItem(order_id=1000, product_id=3001, quantity=1)
order_item2 = OrderItem(order_id=1000, product_id=3002, quantity=2)
order = Order(order_id=1000, customer_id=1, date_ordered="2025-01-01 10:00:00", month_ordered=202501)

Session = sessionmaker(bind=engine)
session = Session()
session.add_all([product1, product2, order, order_item1, order_item2])
session.commit()

print(session.query(Product))
'''
3. Exercise translation
SELECT o.MonthOrdered, SUM(oi.Quantity * p.Price) as Revenue FROM Orders o
    JOIN OrderItems oi on o.OrderID = oi.OrderID
    JOIN Product p on oi.ProductID = p.ProductID
    GROUP BY o.MonthOrdered;
'''

q = Session.query(
         Product, Document, OrderItem,
    ).filter(
         OrderItem.order_id == Order.order_id,
    ).filter(
         OrderItem.product_id == Product.document,
    ).group_by(
        Order.month_ordered
    ).all()