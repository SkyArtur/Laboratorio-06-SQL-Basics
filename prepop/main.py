import os
import dotenv
import mysql.connector
from books import books

dotenv.load_dotenv()

database = {
    'port': 3306,
    'host': 'localhost',
    'user': os.getenv('USER'),
    'password': os.getenv('PASSWORD'),
    'database': os.getenv('DATABASE'),
}

query_insert = """
INSERT INTO books (title, author, published, quantity, price)
    VALUES (%s, %s, %s, %s, price_calculate(%s, 15));
"""


class Connector:
    def __init__(self):
        self.__conn = None
        self.__cursor = None

    def execute(self, query: str, data: tuple = None, fetch: bool = False, commit: bool = False):
        try:
            self.__conn = mysql.connector.connect(**database)
            self.__cursor = self.__conn.cursor()
            self.__cursor.execute(query, data)
        except mysql.connector.Error as err:
            print(err)
        else:
            if fetch:
                return self.__cursor.fetchall()
            if commit:
                self.__conn.commit()
        finally:
            try:
                self.__conn.close()
            except mysql.connector.Error as err:
                print(err)


def prepopulate():
    db = Connector()
    for book in [tuple(item.values()) for item in books]:
        db.execute(query_insert, book, commit=True)


if __name__ == '__main__':
    prepopulate()
