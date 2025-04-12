import mysql.connector

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="Kewal",
        password="Kewal1903!",
        database="project_db"
    )
