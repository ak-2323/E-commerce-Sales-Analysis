 -- 1. Sales & Revenue Analysis -----------------------------------------------------
 
 -- 1.1 How much revenue generated throughout the time period?
SELECT 
    ROUND(SUM(price + shipping_charges),2) AS total_revenue
FROM OrderItems;
 
 -- 1.2 What is the total revenue generated per year?
SELECT 
    YEAR(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price + oi.shipping_charges),2) AS total_revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY total_revenue DESC;

-- 1.3 How much revenue generated according to month?
SELECT 
    MONTH(o.order_purchase_timestamp) AS order_year,
    ROUND(SUM(oi.price + oi.shipping_charges),2) AS total_revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY total_revenue DESC;

-- 1.4 Which product categories generated the most revenue (Top 10)?
SELECT TOP 10
   p.product_category_name,
    ROUND(SUM(oi.price),2) AS total_sales
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY p.product_category_name
ORDER BY total_sales DESC;

-- 1.5 What is the split between product price and shipping revenue?
WITH RevenueCTE AS (
    SELECT 
        SUM(oi.price + oi.shipping_charges) AS overall_revenue,
        SUM(oi.price) AS total_product_revenue,
        SUM(oi.shipping_charges) AS total_shipping_revenue
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
)
SELECT 
    overall_revenue,
    total_product_revenue,
    total_shipping_revenue,
    ROUND(CAST(total_product_revenue AS FLOAT) / overall_revenue,2) AS product_revenue_ratio,
    ROUND(CAST(total_shipping_revenue AS FLOAT) / overall_revenue,2) AS shipping_revenue_ratio
FROM RevenueCTE;

-- 1.6 Which sellers generate the highest revenue (Top 10)?
SELECT TOP 10
    oi.seller_id,
    SUM(oi.price + oi.shipping_charges) AS total_revenue
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY total_revenue DESC;

-- 2. Customer Insights -----------------------------------------------------

-- 2.1 How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS TotalCustomers
FROM Customers;

-- 2.2 How many customers are repeat vs one-time buyers?
SELECT 
    CASE 
        WHEN sub.order_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS customer_type,
    COUNT(*) AS num_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY customer_id
) AS sub
GROUP BY 
    CASE 
        WHEN sub.order_count = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END;

-- 2.3 What is the average spending per customer?
SELECT 
    ROUND(SUM(oi.price + oi.shipping_charges) * 1.0 / COUNT(DISTINCT o.customer_id), 2) AS avg_spending_per_customer
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id;

-- 2.4 Who are the top 10 highest-spending customers?
SELECT TOP 10 
    customer_id,
    SUM(price + shipping_charges) AS total_spent
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 2.5 Which city and state have the most unique customers?
SELECT 
    customer_state,
    customer_city,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM Customers
GROUP BY customer_state, customer_city
ORDER BY unique_customers DESC;

-- 2.6 List of top 10 state by higher revenue
SELECT TOP 10
    c.customer_state,
    ROUND(SUM(oi.price + oi.shipping_charges), 2) AS total_revenue
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- 2.7 List of top 10 city by higher revenue
SELECT TOP 10
    c.customer_city,
    ROUND(SUM(oi.price + oi.shipping_charges), 2) AS total_revenue
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY total_revenue DESC;

-- 3. Order & Delivery Performance -----------------------------------------------------

-- 3.1 Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM Orders;

-- 3.2 Distribution of Order Status
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY order_status;

-- 3.3 What’s the average delivery time vs estimated delivery?
SELECT 
    AVG(DATEDIFF(DAY, order_purchase_timestamp, order_delivered_timestamp)) AS avg_delivery_days,
    AVG(DATEDIFF(DAY, order_purchase_timestamp, order_estimated_delivery_date)) AS avg_estimated_days
FROM Orders
WHERE order_status = 'delivered';

-- 3.4 What % of orders are delivered late?
SELECT 
    CAST(SUM(CASE WHEN order_delivered_timestamp > order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS late_delivery_percentage
FROM Orders
WHERE order_status = 'delivered';

-- 3.5 Delivery delay by product category
SELECT 
    p.product_category_name,
    AVG(DATEDIFF(DAY, o.order_estimated_delivery_date, o.order_delivered_timestamp)) AS avg_delay_days
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_delivered_timestamp > o.order_estimated_delivery_date
GROUP BY p.product_category_name
ORDER BY avg_delay_days DESC;

-- 3.6 Which sellers have the highest percentage of late deliveries?
SELECT 
    oi.seller_id,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN o.order_delivered_timestamp > o.order_estimated_delivery_date THEN 1 ELSE 0 END) AS late_deliveries,
    CAST(SUM(CASE WHEN o.order_delivered_timestamp > o.order_estimated_delivery_date THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS late_delivery_percent
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY late_delivery_percent DESC;

-- 4. Product-Level Analysis -----------------------------------------------------

-- 4.1 Total Products
SELECT COUNT(DISTINCT product_id) AS total_products
FROM Products;

-- 4.2 No. of Product Categories
SELECT COUNT(DISTINCT product_category_name) AS total_product_categories
FROM Products;

-- 4.3 Product categories with Higher No. of Products
SELECT 
    product_category_name,
    COUNT(*) AS total_products
FROM Products
GROUP BY product_category_name
ORDER BY total_products DESC;

-- 4.4 Top 10 most frequently sold products
WITH ProductSales AS (
    SELECT 
        product_id,
        COUNT(*) AS total_sold
    FROM OrderItems
    GROUP BY product_id
)
SELECT TOP 10 
    ps.product_id, 
    p.product_category_name,
    ps.total_sold
FROM ProductSales ps
JOIN Products p ON ps.product_id = p.product_id
ORDER BY ps.total_sold DESC;

-- 4.5 Avg shipping charge by product volume
SELECT 
    p.product_id,
    p.product_category_name,
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) AS volume_cm,
    ROUND(AVG(oi.shipping_charges),2) AS avg_shipping_charge
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_category_name, p.product_length_cm, p.product_height_cm, p.product_width_cm
ORDER BY avg_shipping_charge DESC;

-- 4.6 Which product category has the highest average shipping charge?
SELECT 
    p.product_category_name,
    ROUND(AVG(oi.shipping_charges),2) AS avg_shipping_charge
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY avg_shipping_charge DESC;

-- 5. Payment Insights -----------------------------------------------------

-- 5.1 Most used payment methods
SELECT 
    payment_type,
    COUNT(*) AS total_count
FROM Payments
GROUP BY payment_type
ORDER BY total_count DESC;

-- 5.2 Average installments by payment type
SELECT 
    payment_type,
    AVG(payment_installments) AS avg_installments
FROM Payments
GROUP BY payment_type;

-- 5.3 Do higher-value orders use more installments (credit)?
SELECT 
    CASE 
        WHEN payment_installments = 1 THEN 'Single Payment'
        ELSE 'Installments'
    END AS payment_plan,
    ROUND(AVG(payment_value),2) AS avg_order_value
FROM Payments
GROUP BY 
    CASE 
        WHEN payment_installments = 1 THEN 'Single Payment'
        ELSE 'Installments'
    END;

-- 5.4 What is the distribution of payment types by order status?
SELECT 
    o.order_status,
    p.payment_type,
    COUNT(*) AS payment_count
FROM Payments p
JOIN Orders o ON p.order_id = o.order_id
GROUP BY o.order_status, p.payment_type
ORDER BY o.order_status DESC, payment_count DESC;