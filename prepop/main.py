import os
import json
import dotenv
import mysql.connector

dotenv.load_dotenv()

database = {
    'port': 3306,
    'host': 'localhost',
    'user': os.getenv('USER'),
    'password': os.getenv('PASSWORD'),
    'database': os.getenv('DATABASE'),
}


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

def read_file(filename):
    with open(filename, 'r', encoding='utf8') as file:
        return json.load(file)


def prepopulate():
    # db = Connector()
    print(read_file('prepopulate.json'))
