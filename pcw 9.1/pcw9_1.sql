.mode column
.headers on
PRAGMA foreign_keys = ON;

CREATE TABLE Product (
    ProductID INTEGER PRIMARY KEY,
    Title TEXT,
    Description TEXT,
    Price NUMERIC(11, 2),
    Cost NUMERIC(11, 2)
);

CREATE TABLE Orders (
    OrderID INTEGER PRIMARY KEY,
    CustomerID INTEGER,
    DateOrdered DATETIME,
    MonthOrdered INTEGER,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE OrderItems (
    OrderID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Warehouse (
    WarehouseID INTEGER PRIMARY KEY,
    Name TEXT,
    AddressLine1 TEXT,
    AddressLine2 TEXT,
    AddressLine3 TEXT
);

CREATE TABLE Inventory (
    WarehouseID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Supplier (
    SupplierID INTEGER PRIMARY KEY,
    Name TEXT,
    AddressLine1 TEXT,
    AddressLine2 TEXT,
    AddressLine3 TEXT,
    PhoneNumber TEXT,
    Email TEXT
);
CREATE TABLE SupplierProduct(
    SupplierID INTEGER,
    ProductID INTEGER,
    DaysLeadTime INTEGER,
    Cost NUMERIC(11, 2),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

select DaysLeadTime, AddressLine1 from SupplierProduct 
join Supplier on SupplierProduct.SupplierID = SupplierProduct.SupplierID;

CREATE TABLE SupplierOrders(
    SupplierOrderID INTEGER PRIMARY KEY,
    SupplierID INTEGER,
    ProductID INTEGER,
    WarehouseID INTEGER,
    Quantity INTEGER,
    Status TEXT,
    DateOrdered DATE,
    DateDue DATE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);
CREATE TABLE Customer (
    CustomerID INTEGER PRIMARY KEY,
    FirstName TEXT,
    Surname TEXT,
    AddressLine1 TEXT,
    AddressLine2 TEXT,
    AddressLine3 TEXT,
    PhoneNumber TEXT,
    Email TEXT
);

INSERT INTO Product VALUES (3001, "Widget", "Widge all your worries away!", 99.95, 23.05);
INSERT INTO Product VALUES (3002, "Wodget", "Wodge all your worries away!", 199.95, 123.05);
-- not directly insert 200 CustomerID here bc it's from Customer table --> Foreign Key Constraint failed --> set NULL
INSERT INTO Orders VALUES (1000, NULL, "2025-01-01 10:00:00", 202501);
INSERT INTO OrderItems VALUES (1000, 3001, 1);
INSERT INTO OrderItems VALUES (1000, 3002, 2);

INSERT INTO Warehouse VALUES (4001, "ABC Warehouse", "1374 Elkview Drive", "Fort Lauderdale", "FL 33301");   
INSERT INTO Warehouse VALUES (4002, "XYZ Warehouse", "1576 Walnut Street", "Jackson", "MS 39211");

INSERT INTO Inventory VALUES (4001,3001,3);
INSERT INTO Inventory VALUES (4001,3002,1);
INSERT INTO Inventory VALUES (4002,3001,1);
INSERT INTO Inventory VALUES (4002,3002,4);

INSERT INTO Supplier VALUES (5001, "Widge Suppliers Ltd", "3316 Whitetail Lane", "Irving", "TX 75039","479-357-6159", "TimothyCSilva@widge.com");
INSERT INTO Supplier VALUES (5002, "Wodge Suppliers PLC", "390 Clarksburg Park Road", "Scottsdale", "AZ 85256", "252-441-7555", "JohnAWilley@wodge.co.uk");

INSERT INTO SupplierProduct VALUES (5001, 3001, 3, 23.05);
INSERT INTO SupplierProduct VALUES (5001, 3002, 20, 999.99);
INSERT INTO SupplierProduct VALUES (5002, 3001, 20, 9999.99);
INSERT INTO SupplierProduct VALUES (5002, 3002, 5, 123.05);

INSERT INTO SupplierOrders VALUES (6001, 5001, 3001, 4001, 99, "ORDERED", "2025-01-15", "2025-01-21");
INSERT INTO SupplierOrders VALUES (6002, 5001, 3001, 4002, 99, "DELIVERED", "2025-01-16", "2025-01-23");

INSERT INTO Customer VALUES (2000, "Gertrud", "Karr", "1709 Woodridge Lane", "Memphis", "TN 38110", "559-309-6624", "gkarr@dayrep.com");
INSERT INTO Customer VALUES (2001, "Clara", "Tang", "500 Retreat Avenue", "York", "ME 03909", "312-367-6954", "clara_tang@armyspy.com");

-- SELECT Orders.OrderID, Customer.FirstName, Orders.DateOrdered
-- FROM Orders
-- JOIN Customer ON Orders.CustomerID=Customer.CustomerID;
SELECT 'Product table';
SELECT * FROM Product;
SELECT 'Orders table';
SELECT * FROM Orders;
SELECT 'OrderItems table';
SELECT * FROM OrderItems;
SELECT 'Warehouse table';
SELECT * FROM Warehouse;
SELECT 'Inventory table';
SELECT * FROM Inventory;
SELECT 'Supplier table';
SELECT * FROM Supplier;
SELECT 'SupplierProduct table';
SELECT * FROM SupplierProduct;
SELECT 'SupplierOrders table';
SELECT * FROM SupplierOrders;
SELECT 'Customer table';
SELECT * FROM Customer;

SELECT 'Write a transaction for a delivery from the Widge supplier which has just arrived at the ABC warehouse and unloaded 99 new Widgets.';
-- INSERT INTO Inventory VALUES(WarehouseID, 999, 99); 
-- SELECT WarehouseID FROM Warehouse  
-- JOIN Inventory ON Inventory.WarehouseID =Warehouse.WarehouseID
-- WHERE w.Name = "ABC Warehouse"

-- INSERT INTO SupplierOrders VALUES(6003, 5001, 3001, 4001, )
UPDATE SupplierOrders SET Status = 'DELIVERED' WHERE SupplierID = 3001;
UPDATE Inventory SET Quantity= Quantity+99 WHERE WarehouseID=4001 and ProductID=3001;
SELECT * FROM Inventory;

SELECT 'Write a transaction for a Customer order of 500 Wodgets (3002 pID) which places an order with the cheapest supplier(sp.Cost).)';

INSERT INTO SupplierOrders VALUES (7001, 
    (SELECT SupplierID FROM SupplierProduct WHERE SupplierProduct.Cost = (SELECT MIN(SupplierProduct.Cost) FROM SupplierProduct)), 
    3002, 4001, 500, "ORDERED", "2021-03-08", "2021-03-15");

select ' ';
select 'Stock trading data';
CREATE TABLE StockOrders (
    OrderID INTEGER PRIMARY KEY AUTOINCREMENT, 
    TransType VARCHAR(15),
    Quantity INTEGER,
    FILLED BOOLEAN,
    TradingDeskID, 
    FOREIGN KEY (TradingDeskID) REFERENCES TradingDesks(TradingDeskID)
    );

CREATE TABLE TradingDesks (
    TradingDeskID PRIMARY KEY,
    Name VARCHAR(50),
    StockID INTEGER,
    FOREIGN KEY (StockID) REFERENCES Stocks(StockID));

CREATE TABLE Stocks (
    StockID INTEGER PRIMARY KEY,
    Company VARCHAR(50), 
    PricePerStock NUMERIC(11, 2)
    );
-- ADD CONSTRAINT WHERE SELL < BUY
    
INSERT INTO StockOrders VALUES(NULL, "BUY", 100, 1, 01);
INSERT INTO StockOrders VALUES(NULL, "BUY", 50, 0, 02);
INSERT INTO StockOrders VALUES(NULL, "BUY", 70, 1, 03);
INSERT INTO StockOrders VALUES(NULL, "SELL", 40, 1, 04);
INSERT INTO StockOrders VALUES(NULL, "SELL", 30, 1, 01);

INSERT INTO TradingDesks VALUES(01, "DELTA", 111);
INSERT INTO TradingDesks VALUES(02, "ROCK", 222);
INSERT INTO TradingDesks VALUES(03, "MORGAN", 333);
INSERT INTO TradingDesks VALUES(01, "DELTA", 444);
INSERT INTO TradingDesks VALUES(02, "ROCK", 111);
INSERT INTO TradingDesks VALUES(04, "GOLDMAN", 333);
INSERT INTO TradingDesks VALUES(03, "MORGAN", 222);
    
INSERT INTO Stocks VALUES(111, 'FB', 154.94);
INSERT INTO Stocks VALUES(222, 'STRIPE', 80.04);
INSERT INTO Stocks VALUES(333, 'GG', 200.77);
INSERT INTO Stocks VALUES(444, 'MICRO', 144.34);

--- update filled=1 where...


