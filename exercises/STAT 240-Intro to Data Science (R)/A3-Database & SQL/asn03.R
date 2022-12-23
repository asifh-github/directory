library(RSQLite)

dbcon = dbConnect(SQLite(), dbname="lab03.sqlite")
dbListTables(dbcon)

## 1
query = "PRAGMA table_info('WinterO')"
#returns cols of table in rows

dbGetQuery(dbcon, query)
query1 = "SELECT COUNT(DISTINCT year) AS DistinctYears FROM WinterO"
dbGetQuery(dbcon, query1)

## 2
query2 = "SELECT DISTINCT Height_m FROM Pokem ORDER BY Height_m DESC"
dbGetQuery(dbcon, query2)

## 3
dbGetQuery(dbcon, "PRAGMA table_info('CA')")
dbGetQuery(dbcon, "PRAGMA table_info('POP2011')")

query = "SELECT Population__2011, Region 
FROM CA INNER JOIN POP2011 
ON CA.Geographic_name=POP2011.Geographic_name 
WHERE province=='Saskatchewan'"
QueryOut = dbSendQuery(dbcon, query)
QueryOut
# fetch
dbFetch(QueryOut, 5)
# returns 5 rows
dbFetch(QueryOut, 5)
# returns next 5 rows
dbFetch(QueryOut, -1)
# returns remaining rows
dbClearResult(QueryOut)
# clears memory

## a
query3 = "SELECT * FROM CA"
system.time(for(i in 1:10000) {dbSendQuery(dbcon, query3)} )
## b
query_out3 = dbSendQuery(dbcon, query3)
system.time(for(i in 1:10000) {dbFetch(query_out3, 1)})
## c
# ('dbFetch' method was much faster than 'dbSendQuery'. And that's because 'dbfetch' gets a single row at a time from the query result whereas 'dbSendQuery' sends the query each time.)

## 4
# insert
sql_ins = "INSERT INTO CA 
(Country, Geographic_name, Region, Province, Prov_acr, Latitude, Longitude)
VALUES
('CA', 'V5A', 'Statsville', 'British Columbia', 'BC', '49.278417', '-122.916454'),
('CA', 'V5A', 'Statsville240', 'British Columbia', 'BC', '49.278417', '-122.916454')"
dbSendQuery(dbcon, sql_ins)
sql_ins3 = "SELECT * FROM CA WHERE Region LIKE 'Statsville%'"
dbGetQuery(dbcon, sql_ins3)
# delete
sql_del = "DELETE FROM CA WHERE Region=='Statsville'"
dbSendQuery(dbcon, sql_del)
sql_ins3 = "SELECT * FROM CA WHERE Region LIKE 'Statsville%'"
dbGetQuery(dbcon, sql_ins3)

## a
# (The LIKE operator matches the given pattern with strings in the rows of the query result. Special characters such as '%', '_', & '\' along with other arbitrary characters are used to specify the requirements. For example, % character stands for 0 or more arbitrary characters, _ character stands for exactly 1 arbitrary characters, and \ character is used to escape the special character % and _.)
query41 = "SELECT * FROM CA WHERE Geographic_name LIKE 'V4_'"
dbGetQuery(dbcon, query41)
# (Selects all rows from table CA where column Geographic_names /postal code are 3 letters long and starts with 'V4' and then one single character.)
query42 = "SELECT * FROM CA WHERE Region LIKE '%(%)'"
dbGetQuery(dbcon, query42)
# (Selects all rows from table CA where column Region has brackets '()' in the  Region / city names.)