CREATE DATABASE SalesInventory;
USE SalesInventory;


-- FOR USERS / LOGIN
CREATE TABLE users(
user_ID INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR (50),
email VARCHAR (50),
pass CHAR (50)
);

SELECT * FROM users;

-- FOR MAINTENANCE 
CREATE TABLE ItemCategory (
    CategoryId INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

SELECT * FROM ItemCategory;

CREATE TABLE Supplier (
    SupplierId INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    Address TEXT,
    ContactNumber VARCHAR(15)
);
SELECT * FROM Supplier;

CREATE TABLE Items (
    ItemId INT AUTO_INCREMENT PRIMARY KEY,
    ItemName VARCHAR(100) NOT NULL,
    CategoryId INT NOT NULL,
    BasePrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES ItemCategory(CategoryId)
);

SELECT * FROM Items;
SELECT 
    @ItemId AS ItemId,
    @SalesQuantity AS SalesQuantity,
    BasePrice * @SalesQuantity AS TotalAmount
FROM 
    Items
WHERE 
    ItemId = @ItemId;
-- JOINING FOR MAINTENANCE VIEW
SELECT  i.ItemId , c.CategoryId, c.CategoryName, i.ItemName, i.CategoryId, i.BasePrice FROM Items i
 JOIN ItemCategory c ON c.CategoryId = i.CategoryId;


-- FOR DELIVERY 
CREATE TABLE Delivery (
    DeliveryId INT AUTO_INCREMENT PRIMARY KEY,
    DeliveryDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ItemId INT NOT NULL,
    DeliveryQuantity INT NOT NULL,
    FOREIGN KEY (ItemId) REFERENCES Items(ItemId)
);

SELECT * FROM Delivery;
INSERT INTO Delivery (ItemId, DeliveryQuantity) VALUES (1 , 2009);

CREATE TABLE Inventory (
	InventoryId INT PRIMARY KEY AUTO_INCREMENT,
    ItemId INT,
    inventoryQuantity INT NOT NULL,
    FOREIGN KEY (ItemId) REFERENCES Items(ItemId)
);

SELECT * FROM Inventory;
SELECT 
    Items.ItemId,
    Items.ItemName,
    Items.BasePrice,
    Delivery.DeliveryId,
    Delivery.DeliveryDate,
    Delivery.DeliveryQuantity,
    Inventory.InventoryId,
    Inventory.inventoryQuantity
FROM 
    Items
INNER JOIN 
    Delivery ON Items.ItemId = Delivery.ItemId
INNER JOIN 
    Inventory ON Items.ItemId = Inventory.ItemId;
    
    CREATE VIEW InventoryAvailability AS
SELECT 
    i.ItemId,
    i.ItemName,
    IFNULL(SUM(d.DeliveryQuantity), 0) AS TotalDelivered,
    IFNULL(SUM(s.SalesQuantity), 0) AS TotalSold,
    (IFNULL(SUM(d.DeliveryQuantity), 0) - IFNULL(SUM(s.SalesQuantity), 0)) AS AvailableQuantity
FROM 
    Items i
LEFT JOIN 
    Delivery d ON i.ItemId = d.ItemId
LEFT JOIN 
    Sales s ON i.ItemId = s.ItemId
GROUP BY 
    i.ItemId, i.ItemName;

SELECT * FROM InventoryAvailability;
-- POINT OF SALES
CREATE TABLE Sales (
    ReceiptId INT AUTO_INCREMENT PRIMARY KEY,
    ReceiptDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ItemId INT NOT NULL,
    SalesQuantity INT NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ItemId) REFERENCES Items(ItemId)
);

SELECT 
    Sales.ReceiptId,
    Sales.ReceiptDate,
    Items.ItemId,
    Items.ItemName,
    Items.CategoryId,
    Items.BasePrice,
    Sales.SalesQuantity,
    Sales.TotalAmount
FROM 
    Sales
JOIN 
    Items
ON 
    Sales.ItemId = Items.ItemId
ORDER BY 
    Sales.ReceiptDate DESC;



SELECT * FROM Sales;
  
