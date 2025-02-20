/*Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
name of each branch
number of issued_book,
number of books returned,
total rental generated from books
branch (branch_id) = employees (branch_id) -- branch details
employees(emp_id) = issued_status(issued_emp_id) -- issued book number
issued_status(issued_id) = return_status(issued_id) -- number of returned
*/
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


/*Use the CREATE TABLE AS (CTAS) statement 
to create a new table active_members containing members 
who have issued at least one book in the last 2 months.*/
CREATE TABLE active_members
SELECT * FROM members mb 
WHERE member_id IN (SELECT DISTINCT ist.issued_member_id
 FROM issued_status ist
WHERE ist.issued_date >= CURDATE() - INTERVAL 2 MONTH);
SELECT * FROM active_members;


/*Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees
 who have processed the most book issues. Display the employee name, 
number of books processed, and their branch.*/
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


/* Task 19: Stored Procedure Objective: 
Create a stored procedure to manage the status of 
books in a library system. Description: Write a stored procedure 
that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter.
 The procedure should first check if the book is available (status = 'yes'). 
 If the book is available, it should be issued, and the status 
 in the books table should be updated to 'no'. 
 If the book is not available (status = 'no'), 
 the procedure should return an error message
 indicating that the book is currently not available.*/
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