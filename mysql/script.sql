
INSERT INTO books (title, quantity, price)
    VALUES ('The Last Kingdom', 25, price_calculate(34.5, 17)),
            ('Animal Farm', 18, price_calculate(28.5, 17)),
            ('Fire & Blood', 12, price_calculate(44.5, 22));



UPDATE books SET author='Bernard CornWell' WHERE id = 1;
UPDATE books SET author='George Orwell' WHERE id = 2;
UPDATE books SET author='George R. R. Martin' WHERE id = 3;





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



INSERT INTO authors (name)
    VALUES ('Bernard Cornwell'),
           ('George R. R. Martin'),
           ('J. R. R. Martin'),
           ('George Orwell'),
           ('Stephen King');

INSERT INTO books (title, published, id_author)
    VALUES ('O retorno do rei', '1949', 3),
           ('A sociedade do anel', '1954', 3),
           ('A fúria dos reis', '1998', 2),
           ('A tormenta de espadas', '2000', 2),
           ('Stonehenge', '1999', 1),
           ('O festin do corvo', '2005', 2),
           ('A dança dos dragões', '2011', 2),
           ('A revolução dos bichos', '1945', 4),
           ('1984', '1949', 4),
           ('As duas torres', '1954', 3),
           ('O último reino', '2004', 1),
           ('O cavaleiro da morte', '2005', 1),
           ('Os senhores do norte', '2006', 1),
           ('Carrie', '1974', 5),
           ('O cemitério', '1984', 5),
           ('A canção da espada', '2007', 1),
           ('Terra em chamas', '2009', 1),
           ('Morte dos reis', '2006', 1);
