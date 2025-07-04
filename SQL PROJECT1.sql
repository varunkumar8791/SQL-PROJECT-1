--Create Database--
CREATE DATABASE OnlineBookstore;

--Switch to the database
\c OnlineBookstore;

--Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Auther VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10, 2),
	Stock INT
);
DROP TABLE IF EXISTS customer;
CREATE TABLE Customers (
      Customer_ID SERIAL PRIMARY KEY,
	  Name VARCHAR(100),
	  Email VARCHAR(100),
	  Phone VARCHAR(15),
	  City VARCHAR(50),
	  Country VARCHAR(150)  
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

SELECT *FROM Books;
SELECT *FROM Customers;
SELECT *FROM Orders;

--Import Data into Books Table
COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM "C:\Users\user\Downloads\Books.csv"
CSV HEADER;

--IMPORT DATA into Customers Table
COPY Customer(Customer_ID,NAME,Email,Phone,City,Country)
FROM "C:\Users\user\Downloads\Customers.csv"
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID,Order_Date,Quantity,Total_Amount)
FROM "C:\Users\user\Downloads\Orders.csv"
CSV HEADER;

-- Q1 Retrieve all books in the "Fiction" genre;
SELECT * FROM Books
WHERE Genre='Fiction';

--Q2 Find books published after the year 1958:
SELECT * FROM Books
WHERE Published_year>1950;

--Q3 List all customers from the Canada:

SELECT * FROM Customers
WHERE Country = 'Canada';

--Q4 Show orders placed in november 2023:
SELECT * FROM Orders
WHERE Order_date BETWEEN '2023-11-01' AND '2023-11-30';

--Q5 Retrive the total stock of books aviable:
SELECT SUM(Stock) AS Total_Stock
From Books;

--Q6 Find the detail of the most expensive books:
SELECT * FROM Books ORDER BY Price DESC LIMIT 1; 

--Q7 Show all customers who ordered more than 1 quantity of a books
SELECT * FROM Orders
WHERE quantity>1;

--Q8 Retrive all orders where the total amount exceends $20:
SELECT * FROM Orders
WHERE total_amount>20;

--Q9 List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

--Q10 Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

--11) Calculate the total revenue generated from all orders;
SELECT SUM(total_amount) As Revenue
FROM Orders;


--ADVANCE QUESTION:
--Q1 Retrive the total number of books sold for each genre:
SELECT * FROM ORDERS;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;

--Q2 Find the average price of books in the "Fantasy"Genre;
SELECT AVG(Price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

--Q3 List Customer Who have placed at least 2 orders:
SELECT o.customer_id, c.name,COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c  ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

--Q4 Find the most frequently ordered book:
SELECT o.Book_id, b.title,COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN Books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;

--Q5 Show the top 3 most expensive books of 'Fantasy'Genre:
SELECT * FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

--Q6 Retrive the total quantity of books sold by each author:
SELECT b.Auther, SUM(o.quantity) AS Total_Books_Sold
FROM Orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Auther

--Q7 List the city where customers who spent over $30 are located
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

--Q8 Find the customer who spent the most on orders;
SELECT c.customer_id, c.name,SUM(o.total_amount)AS Total_Spent
FROM orders o
JOIN Customers c ON O.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent DESC LIMIT 1;

--Q9 Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,
     b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_Quantity 
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;






