# Laboratorio-06-SQL-Basics

## SQL - Structured Query Language
Linguagem padrão utilizada em banco de dados relacionais. É dividida em 5 subgrupos:

## DDL - Data Definition Language
Responsável pela manipulação de estruturas de dados como banco de dados, usuários, tabelas, funções, procedimentos, etc
### Comandos:
- **CREATE**
```mysql
CREATE USER 'admin_1'@'localhost' IDENTIFIED BY 'password'; 

CREATE DATABASE bookstore;

CREATE TABLE IF NOT EXISTS books_all (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150), 
    quantity INT,
    price DECIMAL(6, 2)
);

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
```
- **ALTER**
```mysql
ALTER TABLE books_all RENAME TO books;

ALTER TABLE books ADD author_book VARCHAR(15) DEFAULT '' AFTER title;

ALTER TABLE books CHANGE author_book author VARCHAR(15);

ALTER TABLE books MODIFY author VARCHAR(150);
```
- **DROP**
```mysql
DROP TABLE IF EXISTS books;
```

## DCL - Data Control Language
Responsável por controlar autorizações sobre os dados em um SGBD.
### Comandos:
- **GRANT**
```mysql
GRANT ALL PRIVILEGES ON DATABASE bookstore TO admin_1;

GRANT SELECT ON books TO admin_1;
```
- **REVOKE**
```mysql
REVOKE CREATE ON TABLE books FROM admin_1;
```

## DML - Data Manipulation Query
Responsável por realizar inserções, alterações e exclusões no banco de dados.
### Comandos:
- **INSERT**
```mysql
INSERT INTO books (title, quantity, price)
    VALUES ('The Last Kingdom', 25, price_calculate(34.5, 17));

INSERT INTO books (title, quantity, price)
    VALUES ('Animal Farm', 18, price_calculate(28.5, 17)),
            ('Fire & Blood', 12, price_calculate(44.5, 22));
```
- **UPDATE**
```mysql
UPDATE books SET author='Bernard CornWell' WHERE id = 1;

UPDATE books SET author='George Orwell' WHERE title = 'Animal Farm';

```
- **DELETE**
```mysql
DELETE FROM books WHERE id=3;
```
***Importante***: A cláusula *WHERE* é indispensável para garantir a segurança dos dados e filtrar as operações DMLs.
Alguns SGBDs possuem uma programação auxiliar para garantir que estes comandos não sejam realizados sem a presença dela.

## DQL - Data Query Language
Responsável pela realização de consultas no banco de dados.
### Comandos:
- **SELECT**
```mysql
SELECT * FROM books;

SELECT title FROM books WHERE price > 35;
```
## DTL - Data Transaction Language
Responsável por controlar as transações dentro do banco de dados.
- **BEGIN-COMMIT**
```mysql
BEGIN WORK;
    INSERT INTO books (title, author, quantity, price) 
        VALUES ('Farmer Giles of Ham', 'J. R. R. Tolkien', 35, price_calculate(45.65, 25));
COMMIT ;
```
- **BEGIN-ROLLBACK**
```mysql
BEGIN WORK ;
    INSERT INTO books (title, author, quantity, price) 
        VALUES ('Book test 1', 'Author Teste', 35, price_calculate(45.65, 25)),
                ('Book test 2', 'Author Teste', 26, price_calculate(45.32, 12)),
                ('Book test 3', 'Author Teste', 30, price_calculate(52, 25)),
                ('Book test 4', 'Author Teste', 12, price_calculate(106, 12));
ROLLBACK ;
```

