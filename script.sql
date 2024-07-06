CREATE USER 'user'@'host' IDENTIFIED BY 'password';

CREATE DATABASE bookstore;

USE bookstore;

DROP TABLE books;

CREATE TABLE IF NOT EXISTS books_all (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    quantity INT,
    price DECIMAL(6, 2)
);


ALTER TABLE books_all RENAME TO books;
ALTER TABLE books ADD author_book VARCHAR(15) DEFAULT '' AFTER title;
ALTER TABLE books CHANGE author_book author VARCHAR(15);
ALTER TABLE books MODIFY author VARCHAR(150);


INSERT INTO books (title, quantity, price)
    VALUES ('The Last Kingdom', 25, price_calculate(34.5, 17)),
            ('Animal Farm', 18, price_calculate(28.5, 17)),
            ('Fire & Blood', 12, price_calculate(44.5, 22));



UPDATE books SET author='Bernard CornWell' WHERE id = 1;
UPDATE books SET author='George Orwell' WHERE id = 2;
UPDATE books SET author='George R. R. Martin' WHERE id = 3;



delimiter $$
CREATE FUNCTION price_calculate(price DECIMAL(6, 2), profit DECIMAL(5, 2))
    RETURNS DECIMAL(6, 2) DETERMINISTIC
    BEGIN
        IF (profit > 1)
            THEN
            set profit = profit / 100;
        END IF;
        set price = price + (price * profit);
        RETURN ROUND(price, 2);
    END
$$ delimiter ;

DROP FUNCTION price_calculate;

SELECT price_calculate(100, 0.1);

BEGIN WORK;
    INSERT INTO books (title, author, quantity, price)
        VALUES ('Farmer Giles of Ham', 'J. R. R. Tolkien', 35, price_calculate(45.65, 25));
COMMIT ;

BEGIN WORK ;
    INSERT INTO books (title, author, quantity, price)
        VALUES ('Book test 1', 'Author Teste', 35, price_calculate(45.65, 25)),
                ('Book test 2', 'Author Teste', 26, price_calculate(45.32, 12)),
                ('Book test 3', 'Author Teste', 30, price_calculate(52, 25)),
                ('Book test 4', 'Author Teste', 12, price_calculate(106, 12));
ROLLBACK ;

DESCRIBE books;

SELECT * FROM books;

SELECT title FROM books WHERE price > 35;