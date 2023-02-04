use sakila;

-- Write a query to find what is the total business done by each store.
select s.store_id, sum(p.amount)
from payment p 
join staff s using(staff_id)
group by s.store_id;


-- Convert the previous query into a stored procedure.
DELIMITER //
create procedure total_business_store() 
begin
select s.store_id, sum(p.amount)
	from payment p 
	join staff s using(staff_id)
	group by s.store_id;
end //
DELIMITER ;


-- Convert the previous query into a stored procedure that takes the input
-- for store_id and displays the total sales for that store.
DELIMITER //
create procedure total_business_store(in s int) 
begin
select s.store_id, sum(p.amount) as total_sales
	from payment p 
	join staff s using(staff_id)
    where store_id = s
	group by s.store_id;
end //
DELIMITER ;

call total_business_store(1);

drop procedure if exists total_business_store;


-- Update the previous query. Declare a variable total_sales_value of float type,
-- that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.
DELIMITER //
create procedure total_business_store(in s int) 
begin
declare total_sales_value float default 0.0;
select sum(p.amount) as total_sales into total_sales_value
	from payment p 
	join staff s using(staff_id)
    where store_id = s
	group by s.store_id;
select total_sales_value;
end //
DELIMITER ;

call total_business_store(1);

drop procedure if exists total_business_store;


-- In the previous query, add another variable flag. If the total sales value for 
-- the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales 
-- value for that store and flag value.
DELIMITER //
create procedure total_business_store(in s int, out param1 float, out param2 varchar(20)) 
begin
	declare total_sales_value float default 0.0;
    declare flag varchar(20) default "";
    
	select sum(p.amount) as total_sales into total_sales_value
		from payment p 
		join staff s using(staff_id)
		where store_id = s
		group by s.store_id;

	-- select total_sales_value;

	case
		when total_sales_value > 30000 then
        set flag = 'green_flag';
        when total_sales_value < 30000 then
        set flag = 'red_flag';
	end case;
	
    select total_sales_value into param1;
	select flag into param2;
end //
DELIMITER ;

call total_business_store(1, @total_sales, @flag_value);
select @total_sales, @flag_value;











