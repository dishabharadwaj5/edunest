import mysql.connector

def get_db_connection():
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Dhruvabh10!",   # ⚠️ Make sure there is NO space at the end!
        port=3306,              # ✅ (optional but recommended)
        database="miniproj"
    )
    return conn
