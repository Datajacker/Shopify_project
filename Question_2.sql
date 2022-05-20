-- a.	How many orders were shipped by Speedy Express in total?
SELECT  ShipperName, Count(OrderID) AS 'Total order' FROM [Orders] 
LEFT JOIN Shippers
ON Orders.ShipperID = Shippers.ShipperID
GROUP BY Orders.ShipperID
HAVING ShipperName = 'Speedy Express'

-- b.	What is the last name of the employee with the most orders?
WITH RNK AS (
     SELECT EmployeeID, 
       count(OrderID) AS 'Count' 
     FROM [Orders]
     GROUP BY EmployeeID
     ORDER BY Count DESC
     LIMIT 1)
SELECT LastName AS 'Employee_Most_Order'
FROM [Employees]
INNER JOIN RNK
ON Employees.EmployeeID = RNK.EmployeeID

-- c.	What product was ordered the most by customers in Germany?
WITH ORDER_SORTED AS (
     SELECT Customers.CustomerID, 
            Orders.OrderID,
            OrderDetails.ProductID,
            OrderDetails.Quantity
     FROM [Customers]
     INNER JOIN [Orders]
     ON Customers.CustomerID = Orders.CustomerID
     INNER JOIN [OrderDetails]
     ON Orders.OrderID = OrderDetails.OrderID
     WHERE Customers.Country = 'Germany'     
), PRODUCT_MOST AS (
   SELECT ORDER_SORTED.ProductID,
          SUM(ORDER_SORTED.Quantity) AS 'Total'
   FROM ORDER_SORTED
   GROUP BY ORDER_SORTED.ProductID
   ORDER BY Total DESC
   LIMIT 1)

SELECT *
FROM [Products]
INNER JOIN PRODUCT_MOST
ON PRODUCT_MOST.ProductID = Products.ProductID