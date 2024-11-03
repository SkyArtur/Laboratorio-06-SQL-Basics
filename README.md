# Laboratorio-06-SQL-Basics

### Tecnologias utilizadas:
- [Sistema de virtualização - Docker&copy;](https://www.docker.com/)
- [Sistema de Gerenciamento de Banco de Dados - MySQL&copy;](https://www.mysql.com/)
- [Ferramenta Visual de Design de Banco de Dados - MySQL Workbench&copy;](https://www.mysql.com/products/workbench/)

Definindo o SGBD (Sistema de Gerenciamento de Banco de Dados) em um container, utilizando a porta 3300 para evitar conflitos. 

```shell
docker run -d --name mysql --restart=always -v myData:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=212223 -p 3300:3306 mysql:latest
```
## SQL - Structured Query Language
Linguagem padrão utilizada em banco de dados relacionais. É dividida em 5 subgrupos:
## DDL - Data Definition Language
Responsável pela manipulação de estruturas de dados como banco de dados, usuários, tabelas, funções, procedimentos, etc.
### Exemplos de utilização:
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
        SET price = price + (price * profit);
        RETURN ROUND(price, 2);
    END
$$ delimiter ;
```
- **ALTER**
```mysql
ALTER TABLE books ADD author VARCHAR(150) DEFAULT '' AFTER title;
```
- **DROP**
```mysql
DROP TABLE IF EXISTS books;
```
## DCL - Data Control Language
Responsável por controlar autorizações sobre os dados em um SGBD.
### Exemplos de utilização:
- **GRANT**
```mysql
GRANT ALL PRIVILEGES ON DATABASE bookstore TO admin_1;
```
- **REVOKE**
```mysql
REVOKE CREATE ON TABLE books FROM admin_1;
```
## DML - Data Manipulation Query
Responsável por realizar inserções, alterações e exclusões no banco de dados.
### Exemplos de utilização:
- **INSERT**
```mysql
INSERT INTO books (title, author, quantity, price)
    VALUES ('The Last Kingdom', 'Bernard CornWall', 25, price_calculate(34.5, 0.14));
```
- **UPDATE**
```mysql
UPDATE books SET author='Bernard Cornwell' WHERE id = 1;
```
- **DELETE**
```mysql
DELETE FROM books WHERE id=3;
```
***Importante***: A cláusula *WHERE* é indispensável para garantir a segurança dos dados e filtrar as operações DMLs.
Alguns SGBDs possuem uma programação auxiliar para garantir que estes comandos não sejam realizados sem a presença dela.
## DQL - Data Query Language
Responsável pela realização de consultas no banco de dados.
### Exemplos de utilização:
- **SELECT**
```mysql
SELECT * FROM books;
```
## DTL - Data Transaction Language
Responsável por controlar as transações dentro do banco de dados.
- **BEGIN-COMMIT**
```mysql
BEGIN WORK;
    INSERT INTO books (title, author, quantity, price) 
        VALUES ('Farmer Giles of Ham', 'J. R. R. Tolkien', 35, price_calculate(45.65, 0.25));
COMMIT ;
```
- **BEGIN-ROLLBACK**
```mysql
BEGIN WORK ;
    INSERT INTO books (title, author, quantity, price) 
        VALUES ('Book test 1', 'Author Teste', 35, price_calculate(45.65, 0.25)),
                ('Book test 2', 'Author Teste', 26, price_calculate(45.32, 0.12)),
                ('Book test 3', 'Author Teste', 30, price_calculate(52, 0.25)),
                ('Book test 4', 'Author Teste', 12, price_calculate(106, 0.12));
ROLLBACK ;
```

## Exercício de simulação

Deveremos modelar corretamente o banco de dados *bookstore*. Ele deverá ser normalizado de modo a não conter campos nulos
ou multivalorados, os atributos não chave devem ser totalmente dependentes de chaves primárias e os campos não chaves, 
não devem exercer dependência entre si.

Para tanto, modelaremos *bookstore* de modo a existirem 5 entidades que se relacionam entre si como a seguir:

![bookstore](https://github.com/user-attachments/assets/40710603-023b-4b04-ad93-b5788b6be66f)

