-- PROJECT TASK
-- Task 1. Create a New Book Record --
-- ("978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.') "

INSERT INTO `library_project`.`books`
(`Isbn`,
`book_title`,
`category`,
`rental_price`,
`status`,
`author`,
`publisher`)
VALUES
('978-1-60129-456-2',
'To Kill a Mockingbird',
'Classic',
 6.00,
 'yes',
 'Harper Lee', 
 'J.B. Lippincott & Co.');
 
 -- Task 2: Update an Existing Member's Address
 UPDATE members
 set member_address = "125 oak street"
 WHERE member_id = "C103";
 
 
 -- Task 3: Delete a Record from the Issued Status Table 
 -- -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status 
WHERE
    issued_id = 'IS121';
 
 -- Task4: -- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
SELECT 
    issued_book_name AS issued_books,
    issued_member_id AS employee_id
FROM
    issued_status
WHERE
    issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT 
    issued_emp_id AS emp_id, COUNT(issued_id) AS issued_id
FROM
    issued_status
GROUP BY issued_emp_id
HAVING issued_id > 1;

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE issued_book_summary AS SELECT b.Isbn, b.book_title, COUNT(i.issued_id) AS issued_no FROM
    books b
        JOIN
    issued_status AS i ON i.issued_book_isbn = b.Isbn
GROUP BY b.Isbn , b.book_title;
SELECT * FROM issued_book_summary;

-- Task 7. Retrieve All Books in a Specific Category:
SELECT book_title,category FROM books
WHERE category = "Children";

-- Task 8: Find Total Rental Income by ISBN:
SELECT 
    b.category,
    SUM(b.rental_price) AS total_income,
    ist.issued_book_isbn,
    b.book_title
FROM
    books b
        JOIN
    issued_status ist ON ist.issued_book_isbn = b.Isbn
GROUP BY ist.issued_book_isbn
ORDER BY total_income DESC
LIMIT 5;

-- List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date >= CURDATE() -interval 808 day;

-- List Employees with Their Branch Manager's Name and their branch details:
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
 
 
 -- Task Create a Table of Books with Rental Price Above a Certain Threshold:
CREATE TABLE premium_books AS
SELECT * FROM books 
WHERE rental_price >=6;


-- Task 12: Retrieve the List of Books Not Yet Returned
SELECT DISTINCT
    ist.issued_book_name, rst.return_date
FROM
    issued_status AS ist
        LEFT JOIN
    return_status rst ON rst.issued_id = ist.issued_id
WHERE
    rst.return_date IS NULL;

-- Retrieve the category of the most common book (the book with the highest count of issues).
SELECT 
    b.book_title,
    b.category,
    COUNT(ist.issued_id) AS number_of_issued_books
FROM
    books b
        JOIN
    issued_status ist ON ist.issued_book_isbn = b.Isbn
GROUP BY b.book_title , b.category
ORDER BY number_of_issued_books DESC
LIMIT 3;

-- Task 8: Find Total Rental Income by ISBN:
SELECT 
    b.category, SUM(b.rental_price) AS total_income
FROM
    books b
        JOIN
    issued_status ist ON ist.issued_book_isbn = b.Isbn
GROUP BY B.category
ORDER BY total_income DESC;

-- Task 8: Find Total Rental Income by ISBN:
SELECT 
    b.category,
    SUM(b.rental_price) AS total_income,
    ist.issued_book_isbn,
    b.book_title
FROM
    books b
        JOIN
    issued_status ist ON ist.issued_book_isbn = b.Isbn
GROUP BY ist.issued_book_isbn
ORDER BY total_income DESC
LIMIT 5;

-- Task 8: Find Total Rental Income by book and category:
SELECT 
    b.category,
    SUM(b.rental_price) AS total_income,
    COUNT(*),
    b.book_title
FROM
    books b
        JOIN
    issued_status ist ON ist.issued_book_isbn = b.Isbn
GROUP BY B.category , b.book_title
ORDER BY total_income DESC;

-- how many employess under each manager
SELECT 
    empp.emp_name AS manager_name, COUNT(emp.emp_id)
FROM
    employees emp
        JOIN
    branch br ON br.branch_id = emp.branch_id
        JOIN
    employees empp ON empp.emp_id = br.manager_id
GROUP BY empp.emp_id , empp.emp_name;

-- how many employees for specific position
SELECT 
    emp.position, COUNT(*)
FROM
    employees emp
GROUP BY emp.position;

-- Task Create a New return Record --
INSERT INTO library_project.return_status(return_id,issued_id,issued_book_name,return_date,return_book_isbn,book_quality)
values('RS135','IS135','Sapiens: A Brief History of Humankind',NULL,'978-0-307-58837-1','Good');


-- Task Create a New issued  Record --
INSERT INTO library_project.issued_status(
issued_id,
issued_member_id,
issued_book_name,
issued_date,
issued_book_isbn,
issued_emp_id)
values
("IS151","C118","The Catcher in Rye",CURRENT_DATE - INTERVAL 24 DAY,"978-0-553-29698-2","E108"),
("IS152","C119","The Catcher in Rye",CURRENT_DATE - INTERVAL 13 DAY,"978-0-553-29698-2","E109"),
("IS153","C106","Pride and Prejudice",CURRENT_DATE - INTERVAL 7 DAY,"978-0-14-143951-8","E107"),
("IS54","C105","The Road",CURRENT_DATE - INTERVAL 32 DAY,"978-0-375-50167-0","E101");


-- Adding new column in return status
ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(15) DEFAULT("Good");


-- update return_status table
UPDATE return_status
SET book_quality = "Damaged"
WHERE issued_id 
IN("IS112","IS117","IS118");
SELECT * FROM return_status;

 






















