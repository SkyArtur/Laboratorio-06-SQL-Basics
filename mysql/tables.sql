SHOW TABLES;

DROP TABLE IF EXISTS books_sales, stocks, sales, books, authors;

CREATE TABLE IF NOT EXISTS authors(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS books(
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL ,
    published CHAR(4) NOT NULL ,
    id_author INT NOT NULL,
    FOREIGN KEY (id_author)
        REFERENCES authors(id) ON DELETE CASCADE
);

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


