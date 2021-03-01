.mode column
PRAGMA foreign_keys = ON; -- activates foreign key features in sqlite. It is disabled by default

CREATE TABLE Clients (
    CLIENTNUMBER INTEGER PRIMARY KEY, -- needs to be primary key for foriegn_keys to work
    FIRSTNAME VARCHAR(20),
    SURNAME VARCHAR(20),
    EMAIL VARCHAR(100),
    PHONE VARCHAR(20)
);

CREATE TABLE Loans (
    ACCOUNTNUMBER INTEGER, --A unique integer to identify this account
    CLIENTNUMBER INTEGER, -- An integer to identify the client (clients may have more than one account)
    STARTDATE DATETIME, -- The time that this account was created
    STARTMONTH INTEGER, -- The month for which the first repayment is due (201805 means May 2018)
    TERM INTEGER, -- Over how many months the loan must be repaid
    REMAINING_TERM INTEGER, -- How many months remain
    PRINCIPALDEBT NUMERIC(11, 2), -- The size of the initial loan
    ACCOUNTLIMIT NUMERIC(11, 2), --
    BALANCE NUMERIC(11, 2), -- How much is currently owed
    STATUS VARCHAR(11), -- Human readable status - e.g. "PAID OFF", "ARREARS", "NORMAL"
    FOREIGN KEY (CLIENTNUMBER) REFERENCES Clients(CLIENTNUMBER) -- CLIENTNUMBER is the foreign key from Clients table.
);

INSERT INTO Clients VALUES (1, 'Robert', 'Warren', 'RobertDWarren@teleworm.us', '(251) 546-9442');
INSERT INTO Clients VALUES (2, 'Vincent', 'Brown', 'VincentHBrown@rhyta.com', '(125) 546-4478');
INSERT INTO Clients VALUES (3, 'Janet', 'Prettyman', 'JanetTPrettyman@teleworm.us', '(949) 569-4371');
INSERT INTO Clients VALUES (4, 'Martina', 'Kershner', 'MartinaMKershner@rhyta.com', '(630) 446-8851');
INSERT INTO Clients VALUES (5, 'Tony', 'Schroeder', 'TonySSchroeder@teleworm.us', '(226) 906-2721');
INSERT INTO Clients VALUES (6, 'Harold', 'Grimes', 'HaroldVGrimes@dayrep.com', '(671) 925-1352');

INSERT INTO Loans VALUES (1,1,'2017-11-01 10:00:00', 201712, 36, 35, 10000.00, 15000.00, 9800.00, 'NORMAL');
INSERT INTO Loans VALUES (2,2,'2018-01-01 10:00:00', 201802, 24, 24, 1000.00, 1500.00, 1000.00, 'NORMAL');
INSERT INTO Loans VALUES (3,1,'2016-11-01 10:00:00', 201612, 12, -3, 2000.00, 15000.00, 4985.12, 'ARREARS');
INSERT INTO Loans VALUES (4,3,'2018-01-01 10:00:00', 201802, 24, 24, 3500.00, 5000.00, 1300.00, 'NORMAL');
INSERT INTO Loans VALUES (5,4,'2017-11-01 10:00:00', 201712, 12, 35, 10000.00, 15000.00, 0.00, 'PAID OFF');
INSERT INTO Loans VALUES (6,5,'2018-01-01 10:00:00', 201802, 48, 24, 1000.00, 1500.00, 0.00, 'PAID OFF');
INSERT INTO Loans VALUES (7,6,'2015-11-01 10:00:00', 201512, 12, -20, 10000.00, 15000.00, 9800.00, 'Arrears');
INSERT INTO Loans VALUES (7,4,'2018-01-01 10:00:00', 201802, 12, 1, 2400.00, 3600.00, 130.00, 'NORMAL');

-- Is the data there?
SELECT 'Loans';
SELECT '----------------------------------------------------';
SELECT * FROM Loans;
SELECT '';
SELECT 'Clients';
SELECT '----------------------------------------------------';
SELECT * FROM Clients;

SELECT '1. Everyone who owes more than $5,000 on an account:';
SELECT '----------------------------------------------------';
SELECT FIRSTNAME, SURNAME, BALANCE FROM Loans
    JOIN Clients ON Loans.CLIENTNUMBER = Clients.CLIENTNUMBER
    WHERE BALANCE > 5000.00;

SELECT '';
SELECT '2. Find all loans older than Jan 2017';
SELECT * FROM Loans WHERE STARTDATE < '2017-01-01 00:00:00';

SELECT '';
SELECT '3. Find all clients who have more than one loan';
SELECT CLIENTNUMBER, ACCOUNTNUMBER from Loans
        GROUP BY CLIENTNUMBER
        HAVING COUNT(ACCOUNTNUMBER) >1;

SELECT '';
SELECT "4. Find the total balance outstanding over all loans that aren't in arrears";
SELECT SUM(BALANCE) FROM Loans WHERE STATUS NOT IN ("ARREARS");


SELECT '';
SELECT '5. Are all account numbers unique? (How should we fix this in general)';
SELECT ACCOUNTNUMBER FROM Loans 
    GROUP BY ACCOUNTNUMBER
    HAVING COUNT(ACCOUNTNUMBER) >1;

-- duplicates find: select user_id, round, tournament_id
-- from yourtable
-- group by user_id, round, tournament_id
-- having count(*) > 1

SELECT '';
SELECT '6. Martina has undergone gender reassignment and is now Martin';
UPDATE Clients SET FIRSTNAME="Martin" WHERE FIRSTNAME = "Martina";
SELECT * FROM Clients WHERE FIRSTNAME="Martin";

SELECT '';
SELECT '7. Get a list of email addresses for all clients who paid off a loan';
SELECT Clients.EMAIL FROM Loans 
    JOIN Clients ON Loans.CLIENTNUMBER = Clients.CLIENTNUMBER
    WHERE BALANCE =0;


SELECT '';
SELECT '8. Print out the largest loan for each client';
SELECT CLIENTNUMBER, MAX(PRINCIPALDEBT) FROM Loans
    GROUP BY CLIENTNUMBER;
    
-----------------
-- Your startup will be a platform that connects drivers with people who need a lift. You will need to keep track of:

-- the rides taken,
-- billing for riders,
-- monthly payments for drivers.
-- Design all the SQL tables you need to capture the above requirements.
-- Write the CREATE TABLE statements to implement your design.
-- INSERT some example data that you have made up.
-- Write a query to find out how many trips have been made by each driver this month, and how much they will be paid.
-- Write a query to find all the riders who haven't taken any trips this month. (So we can send them an irritating marketing email!)
------
SELECT '';
SELECT 'part 2: Ride sharing';

CREATE TABLE Drivers (
    driver_id INTEGER PRIMARY KEY AUTOINCREMENT, 
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255),
    email varchar(100));

CREATE TABLE Rides (
    ride_id INTEGER PRIMARY KEY AUTOINCREMENT,
    driver_id INTEGER,
    price NUMERIC(11,2),
    date_time DATETIME,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) -- CLIENTNUMBER is the foreign key from Clients table.
    );

INSERT INTO Drivers VALUES(NULL, 'Jackie', 'TRang', '@');
INSERT INTO Drivers VALUES(NULL, 'Abert', 'Einstein', '@2');
INSERT INTO Drivers VALUES(NULL, 'Mark', 'Zuck', '@3');
INSERT INTO Drivers VALUES(NULL, 'Jeff', 'Bezos', '@4');
INSERT INTO  Drivers VALUES(NULL, 'Larry', 'Sanders', '@5');

SELECT * from Drivers;
    
insert into Rides values (null, 1, 10, '2020-01-01 10:00:00');
insert into Rides values (null, 1, 20, '2020-01-10 10:00:00');
insert into Rides values (null, 2, 87, '2020-02-01 10:00:00');
insert into Rides values (null, 3, 40, '2020-02-01 10:00:00');
insert into Rides values (null, 2, 23, '2020-01-01 10:00:00');
insert into Rides values (null, 1, 10, '2020-01-01 10:00:00');
insert into Rides values (null, 1, 10, '2020-01-01 10:00:00');
insert into Rides values (null, 2, 14, '2020-02-01 10:00:00');
insert into Rides values (null, 4, 6, '2020-01-01 10:00:00');
insert into Rides values (null, 4, 30, '2020-01-01 10:00:00');
insert into Rides values (null, 5, 21, '2020-02-02 10:00:00');
insert into Rides values (null, 5, 19, '2020-02-03 10:00:00');

SELECT * from Rides;

SELECT 'find out how many trips have been made by each driver this month, and how much they will be paid.';
SELECT first_name, count(ride_id), sum(price) from Rides
    join Drivers on Rides.driver_id = Drivers.driver_id
    group by Rides.driver_id;

SELECT '';
SELECT "Write a query to find all the riders who haven't taken any trips this month.";
-- select Rides.driver_id, first_name, last_name, count(ride_id) from Rides
--     join Drivers on Rides.driver_id = Drivers.driver_id
--     group by Rides.driver_id
--     having count(select ride_id FROM Rides WHERE '2020-01-01 00:00:00' <=date_time <= '2020-01-31 23:59:00' == 0);
select driver_id,
    sum(case when '2020-01-01 00:00:00' <=date_time <= '2020-01-31 23:59:00' then 1 else 0 end) ThisMonth
    from Rides
    group by driver_id;
    
---select companyId,
--   sum(case when outcomeid = 36 then 1 else 0 end) SalesCount,
--   sum(case when outcomeid <> 36 then 1 else 0 end) NonSalesCount
-- from yourtable
-- group by companyId;


SELECT "Write a query to find all the riders who haven't taken any trips this month";
SELECT '----------------------------------------------------';
SELECT Drivers.first_name, Drivers.driver_id FROM Drivers
    join Rides on Rides.driver_id = Drivers.driver_id
    WHERE Drivers.driver_id NOT IN (SELECT driver_id FROM Rides WHERE strftime('%m', Rides.date_time) = strftime('%m', DATE('now'))) 
    GROUP BY Drivers.driver_id
    HAVING COUNT(ride_id)=0;
