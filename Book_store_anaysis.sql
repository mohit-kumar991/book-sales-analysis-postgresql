CREATE TABLE Books(
	Book_ID int primary key,
	Title varchar(100),
	Author varchar(100),
	Genre varchar(50),
	Published_Year int,
	Price numeric(10,2),
	Stock int);
create table Customers(
	Customer_ID int primary key,
	Name varchar(50),
	Email varchar(100),
	Phone varchar(15),
	City varchar(150),
	Country varchar(100));
create table Orders(
	Order_ID int primary key,
	Customer_ID int references Customers(Customer_ID),
	Book_ID int references Books(Book_ID),
	Order_Date date,
	Quantity int,
	Total_Amount numeric(10,2));

select * from Books;
select * from Customers;
select * from Orders;

--Import data from csv files

--BASIC QURIES

--Q1. Retrieve all book in the "Fiction" genre:
select * from Books
where genre='Fiction';

--Q2. find books published after the year 1950:
select * from Books
where published_year>1950;

--Q3. list all customers from the Canada:
select * from Customers
where Country='Canada';

--Q4. show orders placed in novermber 2023:
select * from Orders
where order_date between '2023-11-01' and '2023-11-30';

--Q5. retrieve the total stock of books available:
select sum(stock) as total_stock from Books;

--Q6. find the details of the most expensive book:
select * from Books
order by price desc limit 1;


--Q7.  show all customers who ordered more than 1 quantity of a book:
select * from Orders
where quantity>1
order by quantity desc;

--Q8. retrieve all orders where the total amount exceeds $20:
select * from Orders
where total_amount>20
order by total_amount desc;

--Q9. list all genres available in the books table:
select distinct genre from Books;

--Q10. calculate the total revenue generated from all orders:
select sum(total_amount) as revenue from Orders;

--ADVANCED QURIES

--Q1. retrieve the total number of books sold for each genre:
select b.genre, sum(o.quantity) as total_book_sold
from orders o join books b
on b.book_id = o.book_id
group by b.genre
order by total_book_sold desc;

--Q2. find all average price of books in the "Fantasy" genre:
select avg(price) as avg_price from books
where genre='Fantasy';

--Q3. list customers who have placed at least 2 orders:
select c.customer_id, c.name, count(order_id)
from orders o join customers c
on c.customer_id = o.customer_id
group by c.customer_id, c.name
having count(order_id)>=2
order by c.customer_id;

--Q4. find the most frequently ordered book:
select book_id, count(order_id) as count_orders
from orders 
group by book_id
order by count_orders desc
limit 1;

--with name
select o.book_id, b.title, count(o.order_id) as count_orders
from orders o join books b
on o.book_id = b.book_id
group by o.book_id, b.title
order by count_orders desc
limit 1;

--Q5. show the top 3 most expensive books of 'fantasy' genre:
select * from Books
where genre= 'Fantasy'
order by price desc
limit 3;

--Q6. retrieve the total quantity of books sold by each author:
select b.author, sum(o.quantity) as total_book_sold
from orders o join books b
on o.book_id = b.book_id
group by b.author
order by total_book_sold desc;

--Q7.list the cities where customers who spent over 30$ are located:
select Distinct c.city, o.total_amount 
from orders o join customers c
on o.customer_id = c.customer_id
where o.total_amount>30
order by o.total_amount;

--Q8. find the customer who spent the most on orders:
select c.customer_id,c.name, sum(o.total_amount) as total_spent
from orders o join customers c
on o.customer_id = c.customer_id
group by c.customer_id, c.name
order by total_spent desc
limit 1;

--Q9. calculate the stock remaining after fulfilling all orders:
select b.book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity,
b.stock-coalesce(sum(o.quantity),0) as remaining_stock
from books b left join orders o
on b.book_id = o.book_id
group by b.book_id
order by b.book_id;