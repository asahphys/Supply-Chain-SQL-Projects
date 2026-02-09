SELECT * FROM customer;
SELECT * FROM supplier;
SELECT * FROM product;
SELECT * FROM orders;
SELECT * FROM orderitem;

SELECT 
    Country,
    COUNT(Id) AS customer_count
FROM customer
GROUP BY Country
ORDER BY customer_count DESC;

SELECT *
FROM product
WHERE IsDiscontinued = 0;

SELECT
    s.CompanyName,
    p.ProductName
FROM supplier s
JOIN product p
    ON s.Id = p.SupplierId;

SELECT *
FROM customer
WHERE Country = 'USA';

SELECT
    p.ProductName,
    oi.UnitPrice
FROM orderitem oi
JOIN product p
    ON oi.ProductId = p.Id
ORDER BY oi.UnitPrice DESC
LIMIT 1;

SELECT
    SupplierId,
    COUNT(*) AS product_count
FROM product
GROUP BY SupplierId
ORDER BY product_count DESC
LIMIT 1;

SELECT
    YEAR(OrderDate)  AS order_year,
    MONTH(OrderDate) AS order_month,
    COUNT(*)         AS total_orders
FROM orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY order_year, order_month;

SELECT COUNT(*) FROM orders;

SELECT
    Country,
    COUNT(*) AS supplier_count
FROM supplier
GROUP BY Country
ORDER BY supplier_count DESC
LIMIT 1;

SELECT
    c.Id,
    c.FirstName,
    c.LastName
FROM customer c
LEFT JOIN orders o
    ON c.Id = o.CustomerId
WHERE o.Id IS NULL;

show tables;
DESCRIBE orderitem;

SELECT 
    p.Id AS product_id,
    p.ProductName,
    COUNT(od.OrderId) AS total_orders
FROM orderitem od
JOIN product p
    ON od.ProductId = p.Id
GROUP BY p.Id, p.ProductName
ORDER BY total_orders DESC;

SELECT 
    YEAR(OrderDate) AS order_year,
    COUNT(Id) AS total_orders
FROM orders
GROUP BY YEAR(OrderDate)
ORDER BY order_year;

SELECT 
    YEAR(o.OrderDate) AS order_year,
    SUM(od.Quantity * od.UnitPrice) AS total_revenue
FROM orders o
JOIN orderitem od
    ON o.Id = od.OrderId
GROUP BY YEAR(o.OrderDate)
ORDER BY order_year;

SELECT 
    c.Id,
    c.FirstName,
    c.LastName,
    c.Country,
    SUM(o.TotalAmount) AS total_order_amount
FROM customer c
JOIN orders o 
    ON c.Id = o.CustomerId
GROUP BY 
    c.Id, c.FirstName, c.LastName, c.Country
HAVING 
    SUM(o.TotalAmount) = (
        SELECT MAX(total_amt)
        FROM (
            SELECT SUM(TotalAmount) AS total_amt
            FROM orders
            GROUP BY CustomerId
        ) t
    );

SELECT 
    c.Id,
    c.FirstName,
    c.LastName,
    c.Country,
    SUM(o.TotalAmount) AS total_order_amount
FROM customer c
JOIN orders o 
    ON c.Id = o.CustomerId
GROUP BY 
    c.Id, c.FirstName, c.LastName, c.Country
ORDER BY 
    total_order_amount DESC;
    
SELECT
    CustomerId,
    OrderDate AS current_order_date,
    LAG(OrderDate) OVER (
        PARTITION BY CustomerId
        ORDER BY OrderDate
    ) AS previous_order_date
FROM orders;

SELECT
    c.Id,
    c.FirstName,
    c.LastName,
    o.OrderDate AS current_order_date,
    LAG(o.OrderDate) OVER (
        PARTITION BY c.Id
        ORDER BY o.OrderDate
    ) AS previous_order_date
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId;
    
SELECT
    s.Id AS supplier_id,
    s.Suppliername,
    SUM(oi.Quantity * oi.UnitPrice) AS total_revenue
FROM supplier s
JOIN product p
    ON s.Id = p.SupplierId
JOIN orderitem oi
    ON p.Id = oi.ProductId
GROUP BY
    s.Id, s.Suppliername
ORDER BY
    total_revenue DESC
LIMIT 3;

DESCRIBE supplier;

SELECT
    s.Id AS supplier_id,
    s.Country,
    SUM(oi.Quantity * oi.UnitPrice) AS total_revenue
FROM supplier s
JOIN product p
    ON s.Id = p.SupplierId
JOIN orderitem oi
    ON p.Id = oi.ProductId
GROUP BY
    s.Id, s.Country
ORDER BY
    total_revenue DESC
LIMIT 3;

SELECT
    c.Id AS customer_id,
    c.FirstName,
    c.LastName,
    c.Country,
    MIN(o.OrderDate) AS first_order_date,
    MAX(o.OrderDate) AS latest_order_date
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId
GROUP BY
    c.Id,
    c.FirstName,
    c.LastName,
    c.Country
HAVING
    MAX(o.OrderDate) <> MIN(o.OrderDate);

SELECT
    o.Id AS order_id,
    p.ProductName,
    s.SupplierName
FROM orders o
JOIN orderitem oi
    ON o.Id = oi.OrderId
JOIN product p
    ON oi.ProductId = p.Id
JOIN supplier s
    ON p.SupplierId = s.Id
ORDER BY o.Id;

SELECT
    o.Id AS order_id,
    p.ProductName,
    s.CompanyName AS supplier_name
FROM orders o
JOIN orderitem oi
    ON o.Id = oi.OrderId
JOIN product p
    ON oi.ProductId = p.Id
JOIN supplier s
    ON p.SupplierId = s.Id
ORDER BY o.Id;

SELECT *
FROM supplier s
JOIN product p
  ON s.Id = p.SupplierId
LIMIT 500;

SHOW COLUMNS FROM supplier;

SELECT
    s.SupplierName,
    SUM(od.UnitPrice * od.Quantity) AS total_revenue
FROM supplier s
JOIN product p
    ON s.SupplierId = p.SupplierId
JOIN order_details od
    ON p.ProductId = od.ProductId
GROUP BY
    s.SupplierName
ORDER BY
    total_revenue DESC
LIMIT 3;

SHOW TABLES;

SELECT
    s.CompanyName,
    SUM(oi.UnitPrice * oi.Quantity) AS total_revenue
FROM supplier s
JOIN product p
    ON s.Id = p.SupplierId
JOIN orderitem oi
    ON p.Id = oi.ProductId
GROUP BY
    s.CompanyName
ORDER BY
    total_revenue DESC
LIMIT 3;

SHOW COLUMNS FROM product;

SELECT
    c.Id,
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country,
    MAX(o.OrderDate) AS latest_order_date
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId
GROUP BY
    c.Id,
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country
HAVING COUNT(o.Id) > 1;

describe customer;
SELECT * FROM customer LIMIT 1;

SELECT
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country,
    MAX(o.OrderDate) AS latest_order_date
FROM customer c
JOIN `orders` o
    ON c.Id = o.CustomerId
GROUP BY
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country
HAVING COUNT(o.Id) > 1
LIMIT 500;

SELECT 
    o.Id AS order_id,
    p.ProductName,
    s.SupplierName
FROM Orders o
INNER JOIN Order_Details od
    ON o.Id = od.OrderId
INNER JOIN Products p
    ON od.ProductId = p.Id
INNER JOIN Suppliers s
    ON p.SupplierId = s.Id
ORDER BY o.Id;

SHOW TABLES;

SELECT
    o.Id AS order_id,
    p.ProductName,
    s.SupplierName
FROM orders o
INNER JOIN orderitem oi
    ON o.Id = oi.OrderId
INNER JOIN product p
    ON oi.ProductId = p.Id
INNER JOIN supplier s
    ON p.SupplierId = s.Id
ORDER BY o.Id;

DESCRIBE supplier;

SELECT
    o.Id AS order_id,
    p.ProductName,
    s.CompanyName AS supplier_name
FROM orders o
INNER JOIN orderitem oi
    ON o.Id = oi.OrderId
INNER JOIN product p
    ON oi.ProductId = p.Id
INNER JOIN supplier s
    ON p.SupplierId = s.Id
ORDER BY o.Id;

SELECT DISTINCT
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone,
    o.order_id
HAVING SUM(od.quantity) > 10;

SHOW TABLES;

SELECT DISTINCT
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone
FROM customer c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN orderitem oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.email,
    c.phone,
    o.order_id
HAVING SUM(oi.quantity) > 10;

DESCRIBE customer;

DESCRIBE orders;

SELECT
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country,
    c.Phone
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId
JOIN orderitem oi
    ON o.Id = oi.order_id
GROUP BY
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country,
    c.Phone,
    o.Id
HAVING SUM(oi.quantity) > 10;

DESCRIBE orderitem;

SELECT
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country,
    c.Phone
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId
JOIN orderitem oi
    ON o.Id = oi.OrderId
GROUP BY
    c.Id,
    c.FirstName,
    c.LastName,
    c.City,
    c.Country,
    c.Phone,
    o.Id
HAVING SUM(oi.Quantity) > 10;

SELECT DISTINCT
    p.Id,
    p.ProductName,
    p.UnitPrice,
    p.UnitsInStock,
    p.SupplierId
FROM product p
JOIN orderitem oi
    ON p.Id = oi.ProductId
WHERE oi.Quantity = 1;

DESCRIBE product;

SELECT DISTINCT
    p.Id,
    p.ProductName,
    p.SupplierId,
    p.UnitPrice,
    p.Package,
    p.IsDiscontinued
FROM product p
JOIN orderitem oi
    ON p.Id = oi.ProductId
WHERE oi.Quantity = 1;

SELECT DISTINCT
    s.Id,
    s.CompanyName,
    s.City,
    s.Country,
    s.Phone
FROM supplier s
JOIN product p
    ON s.Id = p.SupplierId
WHERE p.UnitPrice > 100;

SELECT 
    'Customer' AS Type,
    ContactName,
    City,
    Country,
    Phone
FROM customer
UNION ALL
SELECT
    'Supplier' AS Type,
    ContactName,
    City,
    Country,
    Phone
FROM supplier
ORDER BY Type, ContactName;

DESCRIBE customer;

SELECT 
    'Customer' AS Type,
    CONCAT(FirstName, ' ', LastName) AS ContactName,
    City,
    Country,
    Phone
FROM customer

UNION ALL

SELECT
    'Supplier' AS Type,
    CompanyName AS ContactName,
    City,
    Country,
    Phone
FROM supplier
ORDER BY Type, ContactName;

SELECT 
    Country,
    City,
    CONCAT(FirstName, ' ', LastName) AS ContactName,
    Phone
FROM customer
WHERE (City, Country) IN (
    SELECT City, Country
    FROM customer
    GROUP BY City, Country
    HAVING COUNT(*) > 1
)
ORDER BY Country, City, ContactName;

SHOW TABLES FROM supply_chain;

DESCRIBE orderitem;

DESCRIBE product;

SELECT 
    oi.OrderId,
    SUM((p.UnitPrice - oi.UnitPrice) * oi.Quantity) AS total_amount_saved
FROM orderitem oi
JOIN product p
    ON oi.ProductId = p.Id
GROUP BY oi.OrderId
ORDER BY total_amount_saved DESC;

SHOW TABLES;

DESCRIBE product;

SELECT
    p.Id AS product_id,
    p.ProductName,
    SUM(oi.Quantity) AS total_quantity_sold
FROM orderitem oi
JOIN product p
    ON oi.ProductId = p.Id
GROUP BY p.Id, p.ProductName
ORDER BY total_quantity_sold DESC
LIMIT 5;

SELECT DISTINCT
    p.Id AS product_id,
    p.ProductName,
    s.Id AS supplier_id,
    s.CompanyName AS competitor_supplier
FROM product p
JOIN supplier s
    ON p.SupplierId = s.Id
WHERE p.Id IN (60, 59, 31, 56, 16)
ORDER BY p.ProductName;

DESCRIBE customer;

SELECT
    c.Id AS customer_id,
    CONCAT(c.FirstName, ' ', c.LastName) AS customer_name,
    s.Id AS supplier_id,
    s.CompanyName AS supplier_name,
    c.Country
FROM customer c
JOIN supplier s
    ON c.Country = s.Country
ORDER BY c.Country;

SELECT
    c.Id AS customer_id,
    CONCAT(c.FirstName, ' ', c.LastName) AS customer_name,
    c.Country
FROM customer c
LEFT JOIN supplier s
    ON c.Country = s.Country
WHERE s.Id IS NULL
ORDER BY c.Country;

SELECT
    s.Id AS supplier_id,
    s.CompanyName AS supplier_name,
    s.Country
FROM supplier s
LEFT JOIN customer c
    ON s.Country = c.Country
WHERE c.Id IS NULL
ORDER BY s.Country;

SELECT DISTINCT
    p.Id AS product_id,
    p.ProductName,
    s.Country AS supplying_country
FROM customer c
JOIN orders o
    ON c.Id = o.CustomerId
JOIN orderitem oi
    ON o.Id = oi.OrderId
JOIN product p
    ON oi.ProductId = p.Id
JOIN supplier s
    ON p.SupplierId = s.Id
WHERE c.Country = 'UK'
  AND s.Country <> 'UK'
ORDER BY p.ProductName, supplying_country;










