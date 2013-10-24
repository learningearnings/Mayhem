# To get old data out of the LE system:

## Users
### To select users from the database into CSV
```sql
SELECT 'UserID', 'SchoolID', 'grade', 'usertypeID', 'username', 'useremail', 'userfname', 'userlname', 'dateofbirth', 'recoverypassword'
UNION ALL
SELECT UserID, SchoolID, grade, usertypeID, username, useremail, userfname, userlname, dateofbirth, recoverypassword
FROM tbl_users
WHERE usertypeid IN (1,2,3,5)
  AND usercreated > 20120801 OR userlastlogin > 20120801
INTO OUTFILE '/tmp/users.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Schools
### To select schools from the database into CSV
```sql
SELECT 'SchoolID', 'school', 'min_grade', 'max_grade', 'schooladdress', 'schooladdress2', 'city', 'state', 'schoolzip', 'schoolphone', 'lat', 'lon', 'timezone', 'gmtoffset', 'distribution_model'
UNION ALL
SELECT SchoolID, school, min_grade, max_grade, schooladdress, schooladdress2, cityID, tbl_states.state, schoolzip, schoolphone, lat, lon, timezone, gmtoffset, distribution_model
FROM tbl_schools
INNER JOIN tbl_states ON tbl_states.stateID = tbl_schools.stateID
INTO OUTFILE '/tmp/schools.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Classrooms
### To select classrooms from the database into CSV
```sql
SELECT 'classroomID', 'userID', 'schoolID', 'grade', 'classroomtitle'
UNION ALL
SELECT classroomID, userID, schoolID, grade, classroomtitle
FROM tbl_classrooms
INTO OUTFILE '/tmp/classrooms.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Classroom Person Links
### To get all the classroom person links from the database into CSV
```sql
SELECT 'classroomdetailID', 'classroomID', 'userID'
UNION ALL
SELECT classroomdetailID, classroomID, userID
FROM tbl_classroomdetails
INTO OUTFILE '/tmp/classroom_details.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```


## Points
### From Jimmy:
Here's how we get the student's balances (tbl_pointtypes.pointtypeID dictates Checking or Savings):
For checking:
SELECT ROUND(sum(points),2) as points, userID FROM tbl_points WHERE userID=? AND pointtypeID = 1 GROUP BY userID;

For Savings:
SELECT ROUND(sum(points),2) as points, userID FROM tbl_points WHERE userID=? AND pointtypeID = 2 GROUP BY userID;

Here is how me get the teacher/school admin balances:
SELECT SUM(TeacherAwardAmount) as sum FROM tbl_teacherawards WHERE TeacherID = ?;

Let me know if this is not what you're looking for or need something else.  I'm happy to give you access to this code as well if you don't already have it.
## User Points
### To select points from the database into CSV
```sql
SELECT 'UserID', 'checking_points'
UNION ALL
SELECT UserID, ROUND(sum(points), 2) as checking_points
FROM tbl_points
WHERE pointtypeID=1
GROUP BY UserID
INTO OUTFILE '/tmp/checking_points.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

```sql
SELECT 'UserID', 'saving_points'
UNION ALL
SELECT UserID, ROUND(sum(points), 2) as checking_points
FROM tbl_points
WHERE pointtypeID=2
GROUP BY UserID
INTO OUTFILE '/tmp/saving_points.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

```sql
SELECT 'TeacherID', 'teacher_points'
UNION ALL
SELECT TeacherID, SUM(TeacherAwardAmount) as teacher_points
FROM tbl_teacherawards
GROUP BY TeacherID
INTO OUTFILE '/tmp/teacher_points.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## Otu Codes
```sql
SELECT 'otucodeID', 'issuinguserID', 'schoolID', 'ClassroomID', 'redeeminguserID', 'OTUcode', 'otucodepoint', 'OTUcodeexpires', 'OTUcodeDate', 'OTUcodeRedeemed', 'OTUCodePrinted', 'ebuck', 'status_id', 'TeacherAwardID'
UNION ALL
SELECT * 
FROM tbl_otucodes
WHERE OTUcodeexpires > NOW() AND OTUcodeRedeemed = '0000-00-00 00:00:00'
INTO OUTFILE '/tmp/otu_codes.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```
