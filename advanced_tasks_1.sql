-- SQL project library management system N2


-- Task 13: Identify Members with Overdue Books
/*Write a query to identify members who have overdue books
 (assume a 30-day return period). Display the member's_id, member's name, 
 book title, issue date, and days overdue.
 member = books = issued_status = return_status*/
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


-- task if i want to see howm many books are overdue
SELECT 
    COUNT(*) AS overdue
FROM
    issued_status ist
        LEFT JOIN
    return_status rst ON rst.issued_id = ist.issued_id
WHERE
    rst.return_date IS NULL
        AND CURDATE() - ist.issued_date > 30;
/*Write a query to update the status of
 books in the books table to
 "Yes" when they are returned 
(based on entries in the return_status table).*/

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
