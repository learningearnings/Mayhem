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

# Rewards LE shipped to schools that are on-site at the school (schoolID)
SELECT 'school_id', 'reward_detail_id', 'reward_id', 'reward_title', 'quantity'
UNION ALL
SELECT rd.schoolID, rd.rewarddetailID, r.rewardID, r.rewardtitle, rd.rewardquantity 
FROM tbl_rewarddetails rd 
JOIN tbl_rewards r ON rd.rewardid = r.rewardid 
WHERE rd.rewardquantity > 0 
into outfile '/tmp/rewards_already_shipped_to_schools.csv'
fields terminated by ','
optionally enclosed by '"'
escaped by '\\'
lines terminated by '\n';

# Local rewards created by School Admins or Teachers for the whole School or
# just 1 Classroom
SELECT 'reward_id', 'reward', 'category', 'quantity', 'user_id', 'school_id', 'classroom_id'
UNION ALL
SELECT rl.id, rl.name 'Reward', lrc.name as 'Category', rl.quantity, rl.userid AS 'Teacher', tfs.schoolid, tfc.classroomid
FROM tbl_rewardlocals rl
JOIN tbl_rewards r ON rl.rewardid = r.rewardid
JOIN tbl_localrewardcategories lrc ON rl.localrewardcategoryID = lrc.id
JOIN tbl_filters tf ON rl.filterid = tf.id
JOIN tbl_filterclassrooms tfc on tfc.filterid = tf.id
JOIN tbl_filterstates tfst on tfst.filterid = tf.id
JOIN tbl_filterschools tfs on tfs.filterid = tf.id
JOIN tbl_filterusertypes tfut on tfut.filterid = tf.id
WHERE rl.quantity > 0 
into outfile '/tmp/local_rewards.csv'
fields terminated by ','
optionally enclosed by '"'
escaped by '\\'
lines terminated by '\n';
