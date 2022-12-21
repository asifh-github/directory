from flask import Flask, g, request, jsonify
import pyodbc
from connect_db import connect_db
import sys
import time, datetime


app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'azure_db'):
        g.azure_db = connect_db()
        g.azure_db.autocommit = True
        g.azure_db.set_attr(pyodbc.SQL_ATTR_TXN_ISOLATION, pyodbc.SQL_TXN_SERIALIZABLE)
    return g.azure_db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'azure_db'):
        g.azure_db.close()


@app.route('/login')
def login():
    username = request.args.get('username', "")
    password = request.args.get('password', "")
    cid = -1
    #print (username, password)
    conn = get_db()
    #print (conn)
    cursor = conn.execute("SELECT * FROM Customer WHERE username = ? AND password = ?", (username, password))
    records = cursor.fetchall()
    #print records
    if len(records) != 0:
        cid = records[0][0]
        
    response = {'cid': cid}
    return jsonify(response)



@app.route('/getRenterID')
def getRenterID():
    """
       This HTTP method takes mid as input, and
       returns cid which represents the customer who is renting the movie.
       If this movie is not being rented by anyone, return cid = -1
    """
    mid = int(request.args.get('mid', -1))
    # connect to database
    conn = get_db()
    cid = -1
    # get customer/cid renting the movie/mid 
    query = "SELECT cid FROM Rental WHERE mid=? AND status='open'"
    cursor = conn.execute(query, mid)
    record = cursor.fetchall()
    if len(record) != 0:
        cid = record[0][0]
        
    response = {'cid': cid}
    return response



@app.route('/getRemainingRentals')
def getRemainingRentals():
    """
        This HTTP method takes cid as input, and returns n which represents
        how many more movies that cid can rent.

        n = 0 means the customer has reached its maximum number of rentals.
    """
    cid = int(request.args.get('cid', -1))
    # connect to database
    conn = get_db()
    # Tell ODBC that you are starting a multi-statement transaction
    conn.autocommit = False  
    n = 0
    # get max_movies for customer/cid
    query1 = "SELECT max_movies FROM Customer c, RentalPlan rp WHERE c.pid=rp.pid AND c.cid=?"
    cursor1 = conn.execute(query1, cid)
    record1 = cursor1.fetchall()
    # get number of movies rented in current month for customer/cid
    query2 = "SELECT COUNT(*) FROM Rental WHERE cid=? AND status='open'"
    cursor2 = conn.execute(query2, cid)
    record2 = cursor2.fetchall()
    if (len(record1)!=0 and len(record2)!=0):    
        n = record1[0][0] - record2[0][0]
    conn.autocommit = True

    response = {"remain": n}
    return jsonify(response)



def currentTime():
    ts = time.time()
    return datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')



@app.route('/rent')
def rent():
    """
        This HTTP method takes cid and mid as input, and returns either "success" or "fail".

        It returns "fail" if C1, C2, or both are violated:
            C1. at any time a movie can be rented to at most one customer.
            C2. at any time a customer can have at most as many movies rented as his/her plan allows.
        Otherwise, it returns "success" and also updates the database accordingly.
    """
    cid = int(request.args.get('cid', -1))
    mid = int(request.args.get('mid', -1))
    # connect to database
    conn = get_db()
    # Tell ODBC that you are starting a multi-statement transaction
    conn.autocommit = False

    # C1
    c1 = -1
    # get customer/cid renting the movie/mid 
    query = "SELECT cid FROM Rental WHERE mid=? AND status='open'"
    cursor = conn.execute(query, mid)
    record = cursor.fetchall()
    if len(record) != 0:
        c1 = record[0][0]

    # C2
    c2 = 0
    # get max_movies for customer/cid
    query1 = "SELECT max_movies FROM Customer c, RentalPlan rp WHERE c.pid=rp.pid AND c.cid=?"
    cursor1 = conn.execute(query1, cid)
    record1 = cursor1.fetchall()
    # get number of movies rented in current month for customer/cid
    query2 = "SELECT COUNT(*) FROM Rental WHERE cid=? AND status='open'"
    cursor2 = conn.execute(query2, cid)
    record2 = cursor2.fetchall()
    if (len(record1)!=0 and len(record2)!=0):    
        c2 = record1[0][0] - record2[0][0]

    # check C1 & C2
    if (c1 == -1 and c2 != 0):
        # transact renting of movies to customer
        query = "INSERT INTO Rental VALUES(?, ?, ?, ?)"
        conn.execute(query, cid, mid, currentTime(), 'open')
        response = {"rent": "success"}
        conn.autocommit = True
    else:
        response = {"rent": "fail"}
        conn.rollback()
    #conn.autocommit = True

    #response = {"rent": "success"} OR response = {"rent": "fail"}
    return jsonify(response)
