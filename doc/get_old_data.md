# To get old data out of the LE system:

## Users
### To select users from the database into CSV
```sql
SELECT 'UserID', 'SchoolID', 'grade', 'usertypeID', 'username', 'userfname', 'userlname', 'dateofbirth', 'recoverypassword'
UNION ALL
SELECT UserID, SchoolID, grade, usertypeID, username, userfname, userlname, dateofbirth, recoverypassword
FROM tbl_users
INTO OUTFILE '/tmp/users.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Schools
### To select schools from the database into CSV
```sql
SELECT 'SchoolID', 'school', 'min_grade', 'max_grade', 'schooladdress', 'schooladdress2', 'city', 'state', 'lat', 'lon', 'timezone', 'gmtoffset', 'distribution_model'
UNION ALL
SELECT SchoolID, school, min_grade, max_grade, schooladdress, schooladdress2, cityID, tbl_states.state, lat, lon, timezone, gmtoffset, distribution_model
FROM tbl_schools
INNER JOIN tbl_states ON tbl_states.stateID = tbl_schools.stateID
INTO OUTFILE '/tmp/schools.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Points
### To select points from the database into CSV
```sql
SELECT 'UserID', 'pointsSum'
UNION ALL
SELECT tbl_users.UserID, sum(points)
FROM tbl_users
INNER JOIN tbl_points ON tbl_points.UserID = tbl_users.UserID
GROUP BY UserID
INTO OUTFILE '/tmp/points.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```
