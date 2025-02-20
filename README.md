# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System  
**Level**: Intermediate  
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.

## Project Structure

### 1. Database Setup
![ERD](https://github.com/najirh/Library-System-Management---P2/blob/main/library_erd.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Library Management System
USE library_project;

-- Creating Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
branch_id VARCHAR(10) PRIMARY KEY,
manager_id VARCHAR(10), -- FX
branch_address VARCHAR(50),
contact_number VARCHAR(10)
);

ALTER TABLE branch
MODIFY COLUMN contact_number  varchar(15);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(25),
position VARCHAR(15),
salary int,
branch_id VARCHAR(210)); -- FK

DROP TABLE IF EXISTS books;
CREATE TABLE books(
Isbn VARCHAR(20) PRIMARY KEY,
book_title VARCHAR(75),
category VARCHAR(10),
rental_price float,
status VARCHAR(15),
author VARCHAR(25),
publisher VARCHAR(55)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members(
member_id VARCHAR(10) PRIMARY KEY,
member_name VARCHAR(25),
member_address VARCHAR(75),
reg_date DATE);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(10), -- FK
issued_book_name VARCHAR(75),
issued_date DATE,
issued_book_isbn VARCHAR(25), -- FK
issued_emp_id VARCHAR(10) -- FK
);
DROP TABLE IF EXISTS return_status;

CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
issued_book_name VARCHAR(75),
return_date DATE,
return_book_isbn VARCHAR(20));

-- FOREIGN KEY
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_emp
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id)

```

### 2. CRUD Operations

- **Create**: Inserted sample records into the `books` table.
- **Read**: Retrieved and displayed data from various tables.
- **Update**: Updated records in the `employees` table.
- **Delete**: Removed records from the `members` table as needed.

**Task 1. Create a New Book Record**
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

```sql
INSERT INTO `library_project`.`books`
(`Isbn`,`book_title`,`category`,`rental_price`,`status`,`author`,`publisher`)
VALUES
('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00, 'yes','Harper Lee','J.B. Lippincott & Co.');
```
**Task 2: Update an Existing Member's Address**

```sql
UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';
```

**Task 3: Delete a Record from the Issued Status Table**
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

```sql
DELETE FROM issued_status
WHERE   issued_id =   'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
-- Objective: Select all books issued by the employee with emp_id = 'E101'.
```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'
```


**Task 5: List Members Who Have Issued More Than One Book**
-- Objective: Use GROUP BY to find members who have issued more than one book.

```sql
SELECT 
    issued_emp_id AS emp_id, COUNT(issued_id) AS issued_id
FROM
    issued_status
GROUP BY issued_emp_id
HAVING issued_id > 1;
```

### 3. CTAS (Create Table As Select)

- **Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
CREATE TABLE issued_book_summary AS SELECT b.Isbn, b.book_title, COUNT(i.issued_id) AS issued_no FROM
    books b
        JOIN
    issued_status AS i ON i.issued_book_isbn = b.Isbn
GROUP BY b.Isbn , b.book_title;
SELECT * FROM issued_book_summary;
```


### 4. Data Analysis & Findings

The following SQL queries were used to address specific questions:

Task 7. **Retrieve All Books in a Specific Category**:

```sql
SELECT * FROM books
WHERE category = 'Classic';
```

8. **Task 8: Find Total Rental Income by Category**:

```sql
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1
```

9. **List Members Who Registered in the Last 180 Days**:
```sql
SELECT * FROM members
WHERE reg_date >= CURDATE() -interval 808 day;
```

10. **List Employees with Their Branch Manager's Name and their branch details**:

```sql
SELECT 
    emp.emp_name,
    emp.position,
    br.manager_id,
    emp.emp_id,
    emr.emp_name AS manager_name
FROM
    employees emp
        JOIN
    branch br ON br.branch_id = emp.branch_id
        JOIN
    employees emr ON emr.emp_id = br.manager_id;
 
```

Task 11. **Create a Table of Books with Rental Price Above a Certain Threshold**:
```sql
CREATE TABLE premium_books AS
SELECT * FROM books 
WHERE rental_price >=6;
```

Task 12: **Retrieve the List of Books Not Yet Returned**
```sql
SELECT DISTINCT
    ist.issued_book_name, rst.return_date
FROM
    issued_status AS ist
        LEFT JOIN
    return_status rst ON rst.issued_id = ist.issued_id
WHERE
    rst.return_date IS NULL;
```

## Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**  
Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

```sql
SELECT 
    m.member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    rst.return_date,
    CURDATE() - ist.issued_date AS overdue
FROM
    issued_status ist
        JOIN
    members m ON m.member_id = ist.issued_member_id
        JOIN
    books bk ON bk.Isbn = ist.issued_book_isbn
        LEFT JOIN
    return_status rst ON rst.issued_id = ist.issued_id
WHERE
    rst.return_date IS NULL
        AND CURDATE() - ist.issued_date > 30
ORDER BY 1;
```


**Task 14: Update Book Status on Return**  
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).


```sql
-- Store Procedures
DROP PROCEDURE IF EXISTS add_return_records;
DELIMITER $$
CREATE  PROCEDURE add_return_records(IN p_return_id VARCHAR(10), IN p_issued_id VARCHAR(10) , IN p_book_quality VARCHAR(15))

BEGIN
    -- all logic and code
    -- inserting into return ased into user's input issued_status
    DECLARE v_isbn varchar(50);
    DECLARE  v_book_title varchar(80);
	INSERT INTO return_status(return_id,issued_id,return_date,book_quality)
    VALUES (p_return_id,p_issued_id,current_date(),p_book_quality);
    SELECT issued_book_isbn,issued_book_name INTO v_isbn,v_book_title FROM issued_status 
    WHERE issued_id = p_issued_id;
    
    UPDATE books
    SET status = 'yes'
    where Isbn=v_isbn;
    
     SELECT CONCAT('Thank you for returning the book ', v_book_title) AS message;
END $$
DELIMITER ;


/*SET SQL_SAFE_UPDATES = 0;
UPDATE books
SET status = 'No'
WHERE Isbn NOT IN (SELECT issued_book_isbn FROM issued_status);
SET SQL_SAFE_UPDATES = 1;*/
-- SELECT * FROM books;
/*SET SQL_SAFE_UPDATES = 0;
UPDATE books bk
JOIN issued_status ist ON ist.issued_book_isbn =bk.Isbn
JOIN return_status rst ON rst.issued_id = ist.issued_id
SET status = 'yes';
UPDATE books
SET status = 'No'
WHERE Isbn NOT IN(SELECT issued_book_isbn FROM issued_status);
SET SQL_SAFE_UPDATES = 1;*/
DELETE FROM return_status WHERE return_id = 'RS136';
SELECT* FROM books WHERE Isbn = '978-0-7432-7357-1'
 OR return_id = 'RS136';

call add_return_records('RS2333','IS136','Good')
```




**Task 15: Branch Performance Report**  
Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_details SELECT br.branch_id AS branch,
    COUNT(ist.issued_id) AS total_issued_book,
    SUM(bk.rental_price) AS revenue,
    COUNT(rst.return_id) num_of_returns FROM
    issued_status ist
        JOIN
    employees emp ON emp.emp_id = ist.issued_emp_id
        JOIN
    branch br ON br.branch_id = emp.branch_id
        JOIN
    books bk ON bk.Isbn = ist.issued_book_isbn
        LEFT JOIN
    return_status rst ON rst.issued_id = ist.issued_id
GROUP BY br.branch_id;
SELECT 
    *
FROM
    branch_details;
```

**Task 16: CTAS: Create a Table of Active Members**  
Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

```sql
CREATE TABLE active_members
SELECT * FROM members mb 
WHERE member_id IN (SELECT DISTINCT ist.issued_member_id
 FROM issued_status ist
WHERE ist.issued_date >= CURDATE() - INTERVAL 2 MONTH);
SELECT * FROM active_members;
```


**Task 17: Find Employees with the Most Book Issues Processed**  
Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT 
    COUNT(ist.issued_id) AS num_issued_book,
    emp.emp_name,
    br.branch_id,
    br.branch_address
FROM
    employees emp
        JOIN
    issued_status ist ON ist.issued_emp_id = emp.emp_id
        JOIN
    branch br ON br.branch_id = emp.branch_id
GROUP BY emp.emp_id
ORDER BY num_issued_book DESC
LIMIT 3;
```

**Task 18: Identify Members Issuing High-Risk Books**  
Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    


**Task 19: Stored Procedure**
Objective:
Create a stored procedure to manage the status of books in a library system.
Description:
Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows:
The stored procedure should take the book_id as an input parameter.
The procedure should first check if the book is available (status = 'yes').
If the book is available, it should be issued, and the status in the books table should be updated to 'no'.
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.

```sql
DELIMITER $$
 CREATE PROCEDURE add_status(p_issued_id VARCHAR(10),p_issued_member_id VARCHAR(30),p_issued_book_name VARCHAR(30),p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
 BEGIN 
 DECLARE v_status VARCHAR(10);
 SELECT 
 status
 INTO v_status 
 FROM books
 WHERE Isbn = p_issued_book_isbn;
 IF v_status = 'yes' then
 INSERT INTO issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
 VALUES(p_issued_id,p_issued_member_id,p_issued_book_name,CURRENT_DATE(),p_issued_book_isbn,p_issued_emp_id);
 UPDATE books
 SET status = 'No'
 WHERE Isbn = p_issued_book_isbn;
 SELECT 'Book records added successfully for book isbn : %', p_issued_book_isbn;
ELSE 
  SELECT 'Sorry book is not available';
  END IF;

END$$
DELIMITER ;
SELECT * FROM books 
where Isbn = '978-0-06-025492-6';
 call add_status('IS188','C105','Where the Wild Things Are','978-0-06-025492-6','E110')
```



**Task 20: Create Table As Select (CTAS)**
Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
    The number of overdue books.
    The total fines, with each day's fine calculated at $0.50.
    The number of books issued by each member.
    The resulting table should show:
    Member ID
    Number of overdue books
    Total fines



## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


