import pyodbc
from connect_db import connect_db
from datetime import datetime


def loadRentalPlan(filename, conn):
    """
        Input:
            $filename: "RentalPlan.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "RentalPlan" in the "VideoStore" database on Azure
            2. Read data from "RentalPlan.txt" and insert them into "RentalPlan"
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    ## create reltal plan table
    query1 = "CREATE TABLE RentalPlan(pid INT, pname VARCHAR(50), monthly_fee FLOAT, max_movies INT, PRIMARY KEY(pid))"
    conn.execute(query1)
    ## open related file
    file_rental_plan = open(filename, "r")
    ## read file by lines
    arr = file_rental_plan.readlines()
    ## loop and insert values into table
    for i in range(len(arr)):
        x = arr[i].replace("\n", "")
        x = x.split("|")
        query2 = "INSERT INTO RentalPlan VALUES(?, ?, ?, ?)"
        conn.execute(query2, int(x[0]), x[1], float(x[2]), int(x[3]))
    ## close file
    file_rental_plan.close()
                    

def loadCustomer(filename, conn):
    """
        Input:
            $filename: "Customer.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Customer" in the "VideoStore" database on Azure
            2. Read data from "Customer.txt" and insert them into "Customer".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    ## create customer table
    query1 = "CREATE TABLE Customer(cid INT, pid INT, username VARCHAR(50), password VARCHAR(50), PRIMARY KEY(cid), FOREIGN KEY(pid) REFERENCES RentalPlan(pid) ON DELETE CASCADE)"
    conn.execute(query1)
    ## open related file
    file_customer = open(filename, "r")
    ## read file by lines
    arr = file_customer.readlines()
    ## loop and insert values into table
    for i in range(len(arr)):
        x = arr[i].replace("\n", "")
        x = x.split("|")
        query2 = "INSERT INTO Customer VALUES(?, ?, ?, ?)"
        conn.execute(query2, int(x[0]), int(x[1]), x[2], x[3])
    ## close file
    file_customer.close()


def loadMovie(filename, conn):
    """
        Input:
            $filename: "Movie.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Movie" in the "VideoStore" database on Azure
            2. Read data from "Movie.txt" and insert them into "Movie".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    ## create movie table
    query1 = "CREATE TABLE Movie(mid INT, mname VARCHAR(50), year INT, PRIMARY KEY(mid))"
    conn.execute(query1)
    ## open related file
    file_movie = open(filename, "r")
    ## read file by lines
    arr = file_movie.readlines()
    ## loop and insert values into table
    for i in range(len(arr)):
        x = arr[i].replace("\n", "")
        x = x.split("|")
        query2 = "INSERT INTO Movie VALUES(?, ?, ?)"
        conn.execute(query2, int(x[0]), x[1], int(x[2]))
    ## close file
    file_movie.close()
    

def loadRental(filename, conn):
    """
        Input:
            $filename: "Rental.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Rental" in the VideoStore database on Azure
            2. Read data from "Rental.txt" and insert them into "Rental".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    ## create reltal table
    query1 = "CREATE TABLE Rental(cid INT, mid INT, date_and_time DATETIME, status VARCHAR(6), FOREIGN KEY(cid) REFERENCES Customer(cid) ON DELETE CASCADE, FOREIGN KEY(mid) REFERENCES Movie(mid) ON DELETE CASCADE)"
    conn.execute(query1)
    ## open related file
    file_rental = open(filename, "r")
    ## read file by lines
    arr = file_rental.readlines()
    ## loop and insert values into table
    for i in range(len(arr)):
        x = arr[i].replace("\n", "")
        x = x.split("|")
        query2 = "INSERT INTO Rental VALUES(?, ?, ?, ?)"
        conn.execute(query2, int(x[0]), int(x[1]), datetime.strptime(x[2], "%Y-%m-%d %H:%M:%S"), x[3])
    ## close file
    file_rental.close()



def dropTables(conn):
    conn.execute("DROP TABLE IF EXISTS Rental")
    conn.execute("DROP TABLE IF EXISTS Customer")
    conn.execute("DROP TABLE IF EXISTS RentalPlan")
    conn.execute("DROP TABLE IF EXISTS Movie")



if __name__ == "__main__":
    conn = connect_db()

    dropTables(conn)

    loadRentalPlan("RentalPlan.txt", conn)
    loadCustomer("Customer.txt", conn)
    loadMovie("Movie.txt", conn)
    loadRental("Rental.txt", conn)


    conn.commit()
    conn.close()






