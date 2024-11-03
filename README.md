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

### Modelo Entidade Relacionamento

![bookstore](https://github.com/user-attachments/assets/40710603-023b-4b04-ad93-b5788b6be66f)

### Código SQL

```mysql
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
    date DATE NOT NULL DEFAULT (CURRENT_DATE),
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
```


Para descrever os relacionamentos entre as entidades, vamos analisar cada tabela e suas chaves estrangeiras, que indicam 
as conexões e restrições de integridade referencial entre elas:

#### Tabela authors e books
**Relacionamento**: Um para muitos (1 : N)

**Explicação**: Cada autor pode escrever vários livros, mas cada livro só pode ter um autor associado.

**Implementação**: A chave estrangeira id_author na tabela books referencia a chave primária id da tabela authors. 
O uso de ON DELETE CASCADE indica que, se um autor for removido, todos os livros associados a ele também serão excluídos 
automaticamente.

#### Tabela books e stocks
**Relacionamento**: Um para um (1:1)

**Explicação**: Cada livro tem um registro de estoque correspondente, que indica a quantidade disponível e o preço. 
Este relacionamento de um para um garante que cada entrada de estoque corresponda exclusivamente a um único livro.

**Implementação**: A chave primária id_book na tabela stocks também é uma chave estrangeira que referencia a chave 
primária id da tabela books. Com ON DELETE CASCADE, se um livro for removido, o registro de estoque correspondente 
será excluído automaticamente.

#### Tabela books_sales e a conexão entre books e sales
**Relacionamento**: Muitos para muitos (N : N)

**Explicação**: Este relacionamento indica que cada livro pode estar presente em várias vendas e cada venda pode incluir 
múltiplos livros. Portanto, foi criada a tabela books_sales para representar essa relação.

**Implementação**: A tabela books_sales possui duas chaves estrangeiras: id_book (que referencia books(id)) e id_sale 
(que referencia sales(id)). Isso cria a estrutura necessária para uma relação de muitos para muitos. Note que não há
ON DELETE CASCADE nas chaves estrangeiras de books_sales, então a remoção de um livro ou venda não afeta diretamente 
essa tabela.

#### Tabela sales
**Relacionamento**: A tabela sales representa vendas individuais e se conecta a books por meio da tabela intermediária books_sales.

**Implementação**: Cada venda tem um identificador (id), uma data (date), uma quantidade total de itens vendidos 
(quantity) e um valor total (value). O valor desta tabela fica associado aos livros por meio da tabela books_sales, 
permitindo que várias vendas possam incluir o mesmo livro e que cada venda possa envolver diferentes livros.

***Resumo dos Relacionamentos***

- *authors → books*: Um autor pode ter muitos livros (1 : N).

- *books → stocks*: Cada livro tem um estoque exclusivo (1:1).

- *books ↔ sales (via books_sales)*: Relacionamento muitos para muitos (N : N), pois cada livro pode aparecer em várias 
vendas e cada venda pode incluir vários livros.

***Observações***

- **Constraints de exclusão**: As cláusulas ON DELETE CASCADE garantem que a exclusão de um autor ou livro propague as 
exclusões automaticamente nas tabelas dependentes (books e stocks), enquanto ON DELETE NO ACTION em books_sales 
preserva a integridade sem excluir dados relacionados.
- **Tabela de associação**: A tabela books_sales é crucial para manter o relacionamento N : N
entre livros e vendas, evitando redundâncias e mantendo a estrutura do banco de dados limpa e eficiente.
Essas definições ajudam a garantir a integridade e facilitam a manutenção do banco de dados.

<hr/>

Laboratórios:

[Laboratório 01 - Trabalhando com PostgreSQL e PL/pgSQL.](https://github.com/SkyArtur/Laboratorio-01-PLpgSQL)

[Laboratório 02 - Conectando com o banco de dados.](https://github.com/SkyArtur/Laboratorio-02-Python)

[Laboratório 03 - Conectando com o banco de dados com Node JS.](https://github.com/SkyArtur/Laboratorio-03-Node)

[Laboratório 04 - Criando uma API com express JS.](https://github.com/SkyArtur/Laboratorio-04-Node-Express)

[Laboratório 05 - Gerenciando uma aplicação com Kubernets.](https://github.com/SkyArtur/Laboratorio-05-Kubernetes)

<hr/>