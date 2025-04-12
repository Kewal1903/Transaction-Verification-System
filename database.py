import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="*****",
        password="**********",
        database="project_db"
    )
