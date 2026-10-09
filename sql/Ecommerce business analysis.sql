CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10),

    INDEX idx_customer_unique_id (customer_unique_id)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(150),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g DECIMAL(10,2),
    product_length_cm DECIMAL(10,2),
    product_height_cm DECIMAL(10,2),
    product_width_cm DECIMAL(10,2),
    product_category_name_english VARCHAR(150)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50) NOT NULL,

    order_status VARCHAR(30),

    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    item_revenue DECIMAL(12,2),
    product_revenue DECIMAL(12,2),
    freight_value DECIMAL(12,2),

    item_count INT,
    unique_products INT,
    unique_sellers INT,

    order_year INT,
    order_month VARCHAR(7),

    delivery_days DECIMAL(10,2),
    estimated_delivery_days DECIMAL(10,2),

    is_delivered BOOLEAN,
    is_canceled BOOLEAN,
    is_unavailable BOOLEAN,
    delivery_late BOOLEAN,

    invalid_carrier_sequence BOOLEAN,
    invalid_delivery_sequence BOOLEAN,

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    INDEX idx_orders_customer (customer_id),
    INDEX idx_orders_date (order_purchase_timestamp),
    INDEX idx_orders_status (order_status)
);

CREATE TABLE order_items (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,

    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,

    shipping_limit_date DATETIME,

    price DECIMAL(12,2),
    freight_value DECIMAL(12,2),
    item_revenue DECIMAL(12,2),

    PRIMARY KEY (order_id, order_item_id),  #composite primary key

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_items_seller
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id),

    INDEX idx_items_product (product_id),
    INDEX idx_items_seller (seller_id)
);

CREATE TABLE payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,

    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(12,2),

    PRIMARY KEY (order_id, payment_sequential),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    INDEX idx_payments_type (payment_type)
);

CREATE TABLE reviews (
    review_key INT AUTO_INCREMENT PRIMARY KEY,

    review_id VARCHAR(50),
    order_id VARCHAR(50) NOT NULL,

    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    INDEX idx_reviews_order (order_id),
    INDEX idx_reviews_score (review_score)
);

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

#data loading
LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/customers_clean.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
);

SELECT COUNT(*) FROM customers;

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/products_clean.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    product_category_name,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_category_name_english
);

SELECT COUNT(*) FROM products;

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/sellers_clean.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
);

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/orders_clean.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    item_revenue,
    product_revenue,
    freight_value,
    item_count,
    unique_products,
    unique_sellers,
    order_year,
    order_month,
    delivery_days,
    estimated_delivery_days,
    is_delivered,
    is_canceled,
    is_unavailable,
    delivery_late,
    invalid_carrier_sequence,
    invalid_delivery_sequence
);
SELECT COUNT(*) FROM orders;

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/order_items_clean.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    item_revenue
);
SELECT COUNT(*) FROM order_items;

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/order_payments_clean.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
);

LOAD DATA LOCAL INFILE
'C:/Users/victus/Desktop/data analysis project/data/processed/order_reviews_clean.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
);
SELECT COUNT(*) FROM reviews;


SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*)
FROM order_items

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'reviews', COUNT(*)
FROM reviews

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers;

#test our first join
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.item_revenue
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
LIMIT 10;

#primary key validation
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM customers;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM products;

#foreign key validation
SELECT COUNT(*) AS orphan_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
SELECT COUNT(*) AS orphan_payments
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

#checking Nulls that shouldn't be null
SELECT
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(customer_unique_id IS NULL) AS null_unique_id
FROM customers;


#Business logic validation
##Delivered orders should have delivery date
SELECT COUNT(*) AS invalid_delivered_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

##Canceled orders shouldn't be marked delivered
SELECT COUNT(*) AS inconsistent_status
FROM orders
WHERE order_status = 'canceled'
  AND is_delivered = TRUE;  
  
##Revenue shouldn't be negative
SELECT COUNT(*) AS negative_revenue
FROM orders
WHERE item_revenue < 0;  

#Validate order revenue
SELECT
    o.order_id,
    o.item_revenue AS stored_revenue,
    SUM(oi.item_revenue) AS calculated_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.item_revenue
HAVING ABS(
    o.item_revenue - SUM(oi.item_revenue)
) > 0.01
LIMIT 20;
  
#Validate payment totals
SELECT
    o.order_id,
    o.item_revenue,
    SUM(p.payment_value) AS payment_total
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY
    o.order_id,
    o.item_revenue
LIMIT 20;  

#check review scores(1-5)
SELECT *
FROM reviews
WHERE review_score < 1
   OR review_score > 5;

SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_score
ORDER BY review_score;   

#check order status
SELECT
    order_status,
    COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

#Phase 4 — SQL Business Analysis
##Part A — Sales & Revenue Analytics
#Q1. What is the total revenue generated?
SELECT
    ROUND(SUM(item_revenue), 2) AS total_revenue
FROM orders
WHERE order_status NOT IN ('canceled', 'unavailable');  #15735527.03

#Q2. What is the total number of orders and average order value?
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(item_revenue), 2) AS total_revenue,
    ROUND(
        SUM(item_revenue) / COUNT(*),
        2
    ) AS average_order_value
FROM orders
WHERE order_status NOT IN ('canceled', 'unavailable');
#total_orders, total_revenue, average_order_value
#98207,	15735527.03 ,	160.23

#Q3. What is the monthly revenue trend?
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    ROUND(SUM(item_revenue), 2) AS monthly_revenue
FROM orders
WHERE order_status NOT IN ('canceled', 'unavailable')
  AND order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-09-01'
GROUP BY
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY
    month;
    
#Q4. Which months generated the highest revenue?
SELECT
    YEAR(order_purchase_timestamp) AS year,
    MONTH(order_purchase_timestamp) AS month,
    ROUND(SUM(item_revenue), 2) AS revenue
FROM orders
WHERE order_status NOT IN ('canceled', 'unavailable')
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY revenue DESC
LIMIT 10;    

#Q5. Calculate monthly revenue growth
WITH monthly_sales AS (

    SELECT
        DATE_FORMAT(
            order_purchase_timestamp,
            '%Y-%m'
        ) AS month,

        SUM(item_revenue) AS revenue

    FROM orders

    WHERE order_status NOT IN (
        'canceled',
        'unavailable'
    )

    AND order_purchase_timestamp >= '2017-01-01'
    AND order_purchase_timestamp < '2018-09-01'

    GROUP BY
        DATE_FORMAT(
            order_purchase_timestamp,
            '%Y-%m'
        )
),

growth_calculation AS (

    SELECT
        month,
        revenue,

        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue

    FROM monthly_sales
)

SELECT
    month,

    ROUND(revenue, 2) AS revenue,

    ROUND(previous_month_revenue, 2)
        AS previous_month_revenue,

    ROUND(
        (
            revenue - previous_month_revenue
        )
        / previous_month_revenue * 100,
        2
    ) AS growth_percentage

FROM growth_calculation

ORDER BY month;

##Part B — Customer Analytics
#Q6. How many unique customers do we have
SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;   #96096

#Q7. How many customers are repeat customers?
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS customer_orders;  #2997

#Q8. What percentage of customers are repeat customers?
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN order_count > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        SUM(
            CASE
                WHEN order_count > 1 THEN 1
                ELSE 0
            END
        )
        / COUNT(*) * 100,
        2
    ) AS repeat_customer_percentage

FROM customer_orders;
#total_c, repeat_C,repeat_percent
#96096	2997	3.12

#Q9. Who are our top 10 customers by revenue?
SELECT
    c.customer_unique_id,

    ROUND(
        SUM(o.item_revenue),
        2
    ) AS total_spend

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_status NOT IN (
    'canceled',
    'unavailable'
)

GROUP BY
    c.customer_unique_id

ORDER BY
    total_spend DESC

LIMIT 10;

#Q10 What is the average revenue per customer?
SELECT
    ROUND(
        SUM(o.item_revenue)
        / COUNT(DISTINCT c.customer_unique_id),
        2
    ) AS average_customer_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status NOT IN (
    'canceled',
    'unavailable'
);  #165.65

##Part C — Product Analytics
#Q11. Which product categories generate the most revenue?
SELECT
    COALESCE(
        p.product_category_name_english,
        'Unknown'
    ) AS category,

    ROUND(
        SUM(oi.item_revenue),
        2
    ) AS revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status NOT IN (
    'canceled',
    'unavailable'
)

GROUP BY
    COALESCE(
        p.product_category_name_english,
        'Unknown'
    )

ORDER BY
    revenue DESC;
    
#Q12. What are the top 10 products by revenue?
SELECT
    oi.product_id,

    p.product_category_name_english AS category,

    ROUND(
        SUM(oi.item_revenue),
        2
    ) AS revenue

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status NOT IN (
    'canceled',
    'unavailable'
)

GROUP BY
    oi.product_id,
    p.product_category_name_english

ORDER BY
    revenue DESC

LIMIT 10;   

#Q13. What are the top 3 products within each category?
WITH product_revenue AS (

    SELECT
        p.product_category_name_english AS category,
        oi.product_id,

        SUM(oi.item_revenue) AS revenue

    FROM order_items oi

    JOIN products p
        ON oi.product_id = p.product_id

    JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status NOT IN (
        'canceled',
        'unavailable'
    )

    GROUP BY
        p.product_category_name_english,
        oi.product_id
),

ranked_products AS (

    SELECT
        category,
        product_id,
        revenue,

        DENSE_RANK() OVER (
            PARTITION BY category
            ORDER BY revenue DESC
        ) AS product_rank

    FROM product_revenue
)

SELECT
    category,
    product_id,
    ROUND(revenue, 2) AS revenue,
    product_rank

FROM ranked_products

WHERE product_rank <= 3

ORDER BY
    category,
    product_rank; 
    
#Q14. Which products have the highest average selling price?
SELECT
    product_id,

    ROUND(
        AVG(price),
        2
    ) AS average_price,

    COUNT(*) AS units_sold

FROM order_items

GROUP BY
    product_id

HAVING COUNT(*) >= 10

ORDER BY
    average_price DESC

LIMIT 10;    

##Part D — Operations Analytics
#Q15. What is the average delivery time?
SELECT
    ROUND(
        AVG(delivery_days),
        2
    ) AS average_delivery_days

FROM orders

WHERE order_status = 'delivered'
  AND delivery_days IS NOT NULL;   #12.56
  
#Q16. What percentage of delivered orders were late?
SELECT

    COUNT(*) AS delivered_orders,

    SUM(
        CASE
            WHEN delivery_late = TRUE
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        SUM(
            CASE
                WHEN delivery_late = TRUE
                THEN 1
                ELSE 0
            END
        )
        / COUNT(*) * 100,
        2
    ) AS late_delivery_percentage

FROM orders

WHERE order_status = 'delivered'; 
#delivered,late_order,late_percentage
#96478	7826	8.11 

#Q17. Which states have the longest average delivery time?
SELECT
    c.customer_state,

    ROUND(
        AVG(o.delivery_days),
        2
    ) AS avg_delivery_days,

    COUNT(*) AS delivered_orders

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

WHERE o.order_status = 'delivered'
  AND o.delivery_days IS NOT NULL

GROUP BY
    c.customer_state

HAVING COUNT(*) >= 100

ORDER BY
    avg_delivery_days DESC;

##Part E — Payments & Reviews
#Q18. Which payment method is most popular?
SELECT
    payment_type,

    COUNT(*) AS payment_count,

    ROUND(
        SUM(payment_value),
        2
    ) AS total_payment_value

FROM payments

GROUP BY
    payment_type

ORDER BY
    payment_count DESC;   
    
#Q19. What is the average review score by product category?
SELECT
    p.product_category_name_english AS category,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score,

    COUNT(*) AS review_count

FROM reviews r

JOIN order_items oi
    ON r.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

GROUP BY
    p.product_category_name_english

HAVING COUNT(*) >= 100

ORDER BY
    average_review_score DESC;   #2 photo
    
# Q20. Does late delivery affect review scores?
SELECT

    CASE
        WHEN o.delivery_late = TRUE
        THEN 'Late Delivery'

        ELSE 'On-Time Delivery'
    END AS delivery_status,

    COUNT(*) AS orders,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score

FROM orders o

JOIN reviews r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'

GROUP BY
    CASE
        WHEN o.delivery_late = TRUE
        THEN 'Late Delivery'

        ELSE 'On-Time Delivery'
    END;   
#delivery_status,orders,average_review_score
#On-Time Delivery	88660	4.29
#Late Delivery	7699	2.57
    
    