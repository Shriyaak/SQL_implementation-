
#comments 
/* multi 
line 
comments 
*/
-- easy questions 
-- Q1. retreive the total number of orders placed 
SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders; 

-- Q2. calculate total revenue generated from pizza sales 

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id; 

-- Q3. identify the highest priced pizza 
SELECT 
    pizza_types.pizza_names, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1; 

-- Q4. Identify the mst common pizza size ordered 
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;  

-- Q5. List the top 5 most ordered pizza types along with their quantities
Use pizza_place  ;
SELECT 
    pizza_types.pizza_names AS typess,
    SUM(order_details.quantity) AS quant
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY typess
ORDER BY quant DESC
LIMIT 5; 


-- Intermediate level questions 
-- Q1. join the necessary tables to find the total quantity of each pizza ordered 
SELECT 
    SUM(order_details.quantity), pizza_types.pizza_category
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.pizza_category
ORDER BY SUM(order_details.quantity) DESC; 

-- Q2. determine the distribution of orders by hours of the day 

SELECT 
    HOUR(order_time) AS order_hour, 
    COUNT(order_id) AS order_count
FROM 
    orders
GROUP BY 
    HOUR(order_time);


-- Q3. join the relevant tables to find the category wise distributions of pizzas 
-- this is not actually a intermediate level question but I have just followed the video I referenced it from 
select pizza_category , count(pizza_names) from pizza_types 
group by pizza_category ; 

-- Q4. Group the orders by date and calculate the average number of pizzas ordered per day 
SELECT 
    ROUND(AVG(quantity), 0) AS pizza_avg_per_day
FROM
    (SELECT 
        orders.order_date AS dates,
            SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY dates) AS order_quantity;  
    
    -- Q5. Determine the top most ordered pizza types based on revenue 
    SELECT 
    pizza_types.pizza_names,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.pizza_names
ORDER BY revenue DESC
LIMIT 3; 

-- Advanced 
-- Q1. Calculate the percentage contribution of each pizza type to total revenue 
SELECT 
    pizza_types.pizza_category, 
    ROUND(SUM(order_details.quantity * pizzas.price) / (
        SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price), 2) 
        FROM 
            order_details 
        JOIN 
            pizzas ON pizzas.pizza_id = order_details.pizza_id
    ) * 100, 2) AS revenue 
FROM 
    pizza_types 
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
JOIN 
    order_details ON order_details.pizza_id = pizzas.pizza_id 
GROUP BY 
    pizza_types.pizza_category 
ORDER BY 
    revenue DESC;
 
 -- Q2. analyse the cummulative revenue generated overtime 
SELECT 
    order_date, 
    SUM(revenue) OVER (ORDER BY order_date) AS cum_revenue 
FROM 
    (
        SELECT 
            orders.order_date,
            SUM(order_details.quantity * pizzas.price) AS revenue 
        FROM 
            order_details 
        JOIN 
            pizzas ON order_details.pizza_id = pizzas.pizza_id 
        JOIN 
            orders ON orders.order_id = order_details.order_id 
        GROUP BY 
            orders.order_date
    ) AS sales;

 
 -- Q3. Determine the top 3 most ordered pizza types based on revenue for each pizza category; 
SELECT 
    name, 
    revenue 
FROM 
    (SELECT 
        pizza_category, 
        pizza_names AS name, 
        revenue, 
        RANK() OVER (PARTITION BY pizza_category ORDER BY revenue DESC) AS rn 
    FROM 
        (SELECT 
            pizza_types.pizza_category, 
            pizza_types.pizza_names, 
            SUM(order_details.quantity * pizzas.price) AS revenue 
        FROM 
            pizza_types 
        JOIN 
            pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id 
        JOIN 
            order_details ON order_details.pizza_id = pizzas.pizza_id 
        GROUP BY 
            pizza_types.pizza_category, 
            pizza_types.pizza_names
        ) AS a
    ) AS b 
WHERE 
    rn <= 3;

 
 






 
 
 
 
 
 
 
 
 

 
 
 
 
 

