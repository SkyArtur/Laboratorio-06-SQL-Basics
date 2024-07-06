# ----------------------------------------------------------------------------------------------------------------------
#                                 Testando a sub-linguagem DDL
# ----------------------------------------------------------------------------------------------------------------------
CREATE USER 'estudante'@'localhost' IDENTIFIED BY '212223';

CREATE DATABASE IF NOT EXISTS bookstore;

SHOW TABLES;

DROP TABLE IF EXISTS books_sales, stocks, sales, books, authors;

CREATE TABLE IF NOT EXISTS books_all (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150),
    quantity INT,
    price DECIMAL(6, 2)
);

DESCRIBE books;

ALTER TABLE books_all RENAME TO books;

ALTER TABLE books ADD author VARCHAR(15) DEFAULT '' AFTER title;
ALTER TABLE books CHANGE author id_author INT;

ALTER TABLE books DROP quantity;
ALTER TABLE books DROP price;

ALTER TABLE books MODIFY id_author INT NOT NULL;

CREATE TABLE IF NOT EXISTS authors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL
);

ALTER TABLE books ADD FOREIGN KEY(id_author) REFERENCES authors(id);
# ----------------------------------------------------------------------------------------------------------------------
#                                               Restante das tabelas
# ----------------------------------------------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS stocks(
    id_book INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (id_book) REFERENCES books(id) ON DELETE CASCADE,
    quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(6, 2) NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS sales(
    id INT PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL ,
    quantity INT NOT NULL ,
    value DECIMAL(9, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS books_sales (
    id_book INT NOT NULL,
    id_sale INT NOT NULL,
    FOREIGN KEY (id_book)
        REFERENCES books(id) ON DELETE NO ACTION,
    FOREIGN KEY (id_sale)
        REFERENCES sales(id) ON DELETE NO ACTION
);