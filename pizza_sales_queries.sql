



-- BASIC QUERIES--
-- Q1.Retrieve the total number of orders placed.
select* from pizzahut.orders;

-- Retrieve the total number of orders placed.

select count(order_id)as total_orders  from orders;

-- Q2. Calculate the total revenue generated from pizza sales.

SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
-- Q3.Identify the highest-priced pizza.
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price;
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Q4.Identify the most common pizza size ordered.

SELECT 
    quantity, COUNT(order_details_id) AS total_order
FROM
    order_details
GROUP BY quantity;

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS total_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY total_count DESC
LIMIT 1;

-- Q5.List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

-- INTERMEDIATE QUERIES--
-- Q6.Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_quantity DESC;


-- Q7.Determine the distribution of orders by hour of the day :-
 SELECT 
    HOUR(order_time)as hour, COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);

-- Q8.Join relevant tables to find the category-wise 
-- distribution of pizzas.
SELECT 
    category, COUNT(pizza_type_id) AS countofpizzatype
FROM
    pizza_types
GROUP BY category;


-- Q9.Group the orders by date and calculate the average 
-- number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_ordered_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_per_day;
    
    -- Q10.Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS total_sales
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_sales DESC
LIMIT 3;


-- ADVANCED QUERIES--
-- Q11.Calculate the percentage contribution 
-- of each pizza type to total revenue...

SELECT 
    pizza_types.category,
    ROUND((ROUND(SUM(order_details.quantity * pizzas.price),
                    2) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            2) AS total_per_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY total_per_revenue DESC;

-- Q12 Analyze the cumulative revenue generated over time.

SELECT 
    order_date,
    ROUND(cumulative_rev, 2) AS cumulative_rev
FROM
(
    SELECT 
        o.order_date,
        SUM(SUM(od.quantity * p.price)) OVER (
            ORDER BY o.order_date
        ) AS cumulative_rev
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN orders o 
        ON o.order_id = od.order_id
    GROUP BY o.order_date
) AS sales
ORDER BY order_date;

 -- Q13. Determine the top 3 most ordered pizza types based 
-- on revenue for each pizza category.


SELECT 
    order_date,
    ROUND(cumulative_rev, 2) AS cumulative_rev
FROM
(
    SELECT 
        o.order_date,
        SUM(SUM(od.quantity * p.price)) OVER (
            ORDER BY o.order_date
        ) AS cumulative_rev
    FROM order_details od
    JOIN pizzas p 
        ON od.pizza_id = p.pizza_id
    JOIN orders o 
        ON o.order_id = od.order_id
    GROUP BY o.order_date
) AS sales
ORDER BY order_date;



