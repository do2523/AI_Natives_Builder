CREATE DATABASE PizzeriaDB;
USE PizzeriaDB;

-- Employee
CREATE TABLE Employee (
	EmployeeID INTEGER NOT NULL,
    Name CHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (EmployeeID)
);

-- Waiter
CREATE TABLE Waiter (
	EmployeeID INTEGER NOT NULL,
    TableSection CHAR(50),
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Chef
CREATE TABLE Chef (
	EmployeeID INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Delivery_Driver
CREATE TABLE Delivery_Driver (
	EmployeeID INTEGER NOT NULL,
    LicensePlate CHAR(20),
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Shift
CREATE TABLE Shift (
	ShiftID INTEGER NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Date DATE NOT NULL,
    PRIMARY KEY (ShiftID)
);

-- Works Relationship
CREATE TABLE Works (
	EmployeeID INTEGER NOT NULL,
    ShiftID INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID, ShiftID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY(ShiftID) REFERENCES Shift(ShiftID) ON DELETE CASCADE
);

-- Customer
CREATE TABLE Customer (
	CustomerID INTEGER NOT NULL,
    Name CHAR(100) NOT NULL,
    Phone CHAR(20),
    Email CHAR(100),
    PRIMARY KEY(CustomerID)
);

-- Order
CREATE TABLE `Order` (
	OrderID INTEGER NOT NULL,
    OrderDate DATE NOT NULL,
    Status CHAR(50) NOT NULL DEFAULT 'Pending',
    CustomerID INTEGER NOT NULL,
    Delivery_DriverEmployeeID INTEGER,
    WaiterEmployeeID INTEGER,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE,
    FOREIGN KEY (Delivery_DriverEmployeeID) REFERENCES Delivery_Driver(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (WaiterEmployeeID) REFERENCES Waiter(EmployeeID) ON DELETE CASCADE
);

-- Make Relationship
CREATE TABLE Make (
	EmployeeID INTEGER NOT NULL,
    OrderID INTEGER NOT NULL,
    PRIMARY KEY (EmployeeID, OrderID),
    FOREIGN KEY (EmployeeID) REFERENCES Chef(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE
);

-- Pizza
CREATE TABLE Pizza (
	PizzaID INTEGER NOT NULL,
    Name CHAR(100) NOT NULL,
    Size CHAR(20) NOT NULL,
    Price DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (PizzaID)
);

-- Contains Relationship
CREATE TABLE Contains (
	OrderID INTEGER NOT NULL,
    PizzaID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (OrderID, PizzaID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (PizzaID) REFERENCES Pizza(PizzaID) ON DELETE CASCADE
);

-- Ingredient
CREATE TABLE Ingredient (
	IngredientID INTEGER NOT NULL,
    Name CHAR(100) NOT NULL,
    Unit CHAR(100) NOT NULL,
    PRIMARY KEY (IngredientID)
);

-- Made_Up_Of Relationship
CREATE TABLE Made_Up_Of (
	PizzaID INTEGER NOT NULL,
    IngredientID INTEGER NOT NULL,
    AmountNeeded DECIMAL(6,2) NOT NULL,
    PRIMARY KEY (PizzaID, IngredientID),
    FOREIGN KEY (PizzaID) REFERENCES Pizza(PizzaID) ON DELETE CASCADE,
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID) ON DELETE CASCADE
);

-- Inventory 
CREATE TABLE Inventory (
	InventoryID INTEGER NOT NULL,
    Location CHAR(100),
    PRIMARY KEY (InventoryID)
);

-- InventoryItem
CREATE TABLE InventoryItem (
	ItemID INTEGER NOT NULL,
    Quantity DECIMAL(8,2) NOT NULL,
    RestockLevel DECIMAL(8,2) NOT NULL,
    InventoryID INTEGER NOT NULL,
    PRIMARY KEY (ItemID),
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID) ON DELETE CASCADE
);

-- Found_In Relationship
CREATE TABLE Found_In (
	IngredientID INTEGER NOT NULL,
    ItemID INTEGER NOT NULL,
    PRIMARY KEY (IngredientID, ItemID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID) ON DELETE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES InventoryItem(ItemID) ON DELETE CASCADE
);

-- Add/Insert Employee, Pizza, Order
INSERT INTO Employee (EmployeeID, Name, Salary)
VALUES (1, 'John Smith', 50000);

INSERT INTO Pizza (PizzaID, Name, Size, Price)
VALUES (1, 'Cheese Pizza', '14"', 5.99);

INSERT INTO Customer (CustomerID, Name, Phone, Email)
VALUES (1, 'Jane Doe', '555-1234', 'jane@example.com');

INSERT INTO `Order` 
(OrderID, OrderDate, Status, CustomerID, Delivery_DriverEmployeeID, WaiterEmployeeID)
VALUES 
(1, '2026-04-24', 'Preparing', 1, NULL, NULL);

-- Update Employee, Pizza, Order
UPDATE Employee
SET Salary = 60000
WHERE EmployeeID = 1;

UPDATE Pizza
SET Price = 2.98
WHERE PizzaID = 1;

INSERT INTO Employee (EmployeeID, Name, Salary)
VALUES (2, 'UCF Driver Guy', 40000);

INSERT INTO Delivery_Driver (EmployeeID, LicensePlate)
VALUES (2, 'ABC123');

UPDATE `Order`
SET Delivery_DriverEmployeeID = 2
WHERE OrderID = 1;


-- Search Employees by role
SELECT *
FROM Waiter;

-- Track and Update order status
UPDATE `Order`
SET Status = 'Delivered'
WHERE OrderID = 1;

SELECT Status
FROM `Order`
WHERE OrderID = 1;

-- Search and filter pizzas by ingredient
SELECT p.Name
FROM Pizza p
JOIN Made_Up_Of m ON p.PizzaID = m.PizzaID
WHERE m.IngredientID = 1;

INSERT INTO Shift (ShiftID, StartTime, EndTime, Date)
VALUES (1, '09:00:00', '17:00:00', '2026-04-24');

-- Handle scheduling of employees
INSERT INTO Works (EmployeeID, ShiftID)
VALUES (1, 1);

SELECT e.EmployeeID, s.StartTime, s.EndTime
FROM Works w
JOIN Employee e ON w.EmployeeID = e.EmployeeID
JOIN Shift s ON w.ShiftID = s.ShiftID;

DELETE FROM Works
WHERE EmployeeID = 1 AND ShiftID = 1;

-- Track ingredient stock (add/insert, update, delete ingredients and inventory items)
INSERT INTO Ingredient (IngredientID, Name, Unit)
VALUES (1, 'Cheese', '3 Pounds');

UPDATE Ingredient
SET Unit = '5 Pounds'
WHERE IngredientID = 1;

DELETE FROM Ingredient
WHERE IngredientID = 1;

INSERT INTO Inventory (InventoryID, Location)
VALUES (1, 'Main Storage');

INSERT INTO InventoryItem(ItemID, Quantity, RestockLevel, InventoryID)
VALUES (1, 1, 1, 1);

UPDATE InventoryItem
SET Quantity = 2
WHERE ItemID = 1 AND InventoryID = 1;

DELETE FROM InventoryItem
WHERE ItemID = 1 AND InventoryID = 1;

-- Report for ingredient/inventory restock
SELECT ItemID, Quantity, RestockLevel
FROM InventoryItem
WHERE Quantity < RestockLevel;

-- Views
CREATE VIEW OrderSummary AS
SELECT o.OrderID, o.OrderDate, o.Status, c.Name AS CustomerName
FROM `Order` o
JOIN Customer c ON o.CustomerID = c.CustomerID;

CREATE VIEW PizzaSales AS
SELECT p.Name, SUM(c.Quantity) AS TotalSold
FROM Contains c
JOIN Pizza p ON c.PizzaID = p.PizzaID
GROUP BY p.Name;

DELETE FROM `Order`
WHERE OrderID = 1;

DELETE FROM Pizza
WHERE PizzaID = 1;

DELETE FROM Employee
WHERE EmployeeID = 1;

SHOW TABLES;
SELECT * FROM Employee;
SELECT * FROM `Order`;