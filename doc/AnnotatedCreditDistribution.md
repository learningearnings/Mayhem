# Learning Earnings First of Month routine

This mysql stored procedure allocates bucks to schools and teachers based on the number of
active students.

## Figure out the month we're in
```
    select now() into @rightnow;
    select concat(extract(YEAR_MONTH from CURRENT_DATE),'01') into @thismonth;
    select concat(extract(YEAR_MONTH from date_sub(CURRENT_DATE,interval 1 month)),'01') into @lastmonth;
    select @lastmonth into @cutoffdate;
```

## Zero out any unused teacher awards from last month
```
    INSERT INTO tbl_teacherawards (TeacherAwardTypeID, TeacherID, StudentID, ClassroomID, TeacherAwardAmount, AwardDate,status_id)
                (SELECT 1,TeacherID,0,0,0-SUM(TeacherAwardAmount),@rightnow,200
                       FROM tbl_teacherawards
                       GROUP BY TeacherID
                       HAVING SUM(TeacherAwardAmount) > 0);-- limit 10 ;
```

## Deactivate School awards for this month
*  Make an attempt at deactivating schoolawards that might have already been inserted
   for this month.   Intent is to be able to re-run this stored procedure

```
    /* school account */
    update tbl_schoolawards tsa set status_id = 300 where extract(YEAR_MONTH from tsa.schoolawarddate) = extract(YEAR_MONTH from @thismonth);
```

## Un-(de)activate students / teachers

```
    -- Give non-participating teachers a chance to become participating if this is run for a second time
    delete from tbl_participatingusers where awardmonth = @thismonth and participating = 0;
```

## Figure out the Active students / teachers

```
    /* Students who have logged in or were created last month */
    insert into tbl_participatingusers (userid,userlastlogin,participating,awardmonth,createddate)
           select tu.userid,tu.userlastlogin,1,@thismonth,@rightnow
           from   tbl_users tu
                  inner join tbl_schools ts on ts.status_id = 200 and tu.schoolID = ts.schoolID
                  left join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                                          tpu.awardmonth = @thismonth and
                                                          tpu.participating = 1
           where  tu.status_id = 200 and
                  tpu.id is null and
                  tu.usertypeID in (1) and
                  (tu.userlastlogin > @cutoffdate or extract(YEAR_MONTH from tu.usercreated) = extract(YEAR_MONTH from @lastmonth));

    /* teachers that were created last month are counted as participating */
    insert into tbl_participatingusers (userid,userlastlogin,participating,awardmonth,createddate)
           select tu.userid,tu.userlastlogin,1,@thismonth,@rightnow
           from   tbl_users tu
                  inner join tbl_schools ts on ts.status_id = 200 and tu.schoolID = ts.schoolID
                  left join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                                          tpu.awardmonth = @thismonth and
                                                          tpu.participating = 1
           where  tu.status_id = 200 and
                  tpu.id is null and
                  tu.usertypeID in (2,3,5) and
                  extract(YEAR_MONTH from tu.usercreated) = extract(YEAR_MONTH from @lastmonth);

    /* teachers that awarded bucks last month are counted as participating */
    insert into tbl_participatingusers (userid,userlastlogin,participating,awardmonth,createddate)
           select tu.userid,tu.userlastlogin,1,@thismonth,@rightnow
           from   tbl_users tu
                  inner join tbl_schools ts on ts.status_id = 200 and tu.schoolID = ts.schoolID
                  left join (select distinct teacherid
                             from tbl_teacherawards tta
                             where tta.awarddate between @lastmonth and @thismonth and tta.teacherawardtypeid in (3,12)) teacherawards on teacherawards.teacherid = tu.userID
                  left join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                                          tpu.awardmonth = @thismonth and
                                                          tpu.participating = 1
           where teacherawards.teacherid is not null and tpu.id is null and tu.status_id = 200;


    /* All other teachers are counted as not participating (and not already in the table for this month)  */
    insert into tbl_participatingusers (userid,userlastlogin,participating,awardmonth,createddate)
           select tu.userid,tu.userlastlogin,0,@thismonth,@rightnow
           from   tbl_users tu
                  inner join tbl_schools ts on ts.status_id = 200 and tu.schoolID = ts.schoolID
                  left join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                                          tpu.awardmonth = @thismonth
           where  tu.status_id = 200 and
                  tpu.id is null and
                  tu.usertypeID in (2,3,5);
```
## If a school doesn't have any participating teachers, but has participating students, anoint one teacher as participating
School administrators get any remainder bucks left if any
```
    update tbl_participatingusers tpu
    inner join (
    select substring_index(group_concat(case when tpuNPTeacher.userID is not null then tpuNPTeacher.id else NULL end order by tu.usertypeid desc,tpuNPTeacher.userID asc  SEPARATOR ',' ),',',1) as ids
    from tbl_schools ts
         inner join tbl_users tu on ts.schoolid = tu.schoolid and
                                           tu.status_id = 200 and
                                           tu.usertypeid in (1,2,3,5)
         left join tbl_participatingusers tpuPTeacher on tu.userid = tpuPTeacher.userid and
                                                         tpuPTeacher.awardmonth = @thismonth and
                                                         tu.usertypeid in (2,3,5) and
                                                         tpuPTeacher.participating  = 1
         left join tbl_participatingusers tpuNPTeacher on tu.userid = tpuNPTeacher.userid and
                                                         tpuNPTeacher.awardmonth = @thismonth and
                                                          tpuNPTeacher.participating  = 0
         left join tbl_participatingusers tpuStudent on tu.userid = tpuStudent.userid and
                                                        tpuStudent.awardmonth = @thismonth and
                                                        tu.usertypeid in (1) and
                                                        tpuStudent.participating  = 1
    where ts.status_id = 200
    group by ts.schoolid having count(tpuPTeacher.userID) = 0 and
                                count(tpuNPTeacher.userID) > 0 and
                                count(tpuStudent.userID) > 0 ) anointed on anointed.ids = tpu.id
    set participating = 1;
```



```
-- insert a row for all active schools, even if they didn't have any students that logged in
insert into tbl_schoolawards (schoolID,teacherawardtypeID,schoolAwardAmount,schoolawarddate,status_id,createdby,description)
select ts.schoolID,2,count(tpu.userID) * 700 as bucks,@rightnow,200,0,concat('Monthly award for ',monthname(CURRENT_DATE),' for ',count(tpu.userID), ' students') as description
from tbl_schools ts
     left join tbl_users tu on ts.schoolID = tu.schoolID and tu.usertypeid = 1
     left join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                             tpu.participating = 1 and
                                             tpu.awardmonth = @thismonth
where
     ts.status_id = 200
group by ts.schoolID;
```



-- Award the rounded down amount per share to each participating teacher

insert into tbl_teacherawards (teacherawardtypeid,
                               teacherid,
                               studentid,
                               classroomid,
                               teacherawardamount,
                               awarddate,
                               status_id,
                               createdby)
select 2,
       teachers.teacherID,
       0,
       0,
       floor(tsa.schoolawardamount / (schools.shares / teachers.shares)) as teacherbucks,
       @rightnow,
       200,
       0
from (
     select tu.schoolID, sum(cast(ifnull(tua.attributevalue,1) as unsigned)) shares
     from tbl_users tu
          inner join tbl_schools ts on ts.schoolID = tu.schoolID and ts.status_id = 200
          inner join tbl_participatingusers tpu on tpu.userid = tu.userID and tpu.awardmonth = @thismonth and tpu.participating = 1
          left join tbl_userattributes tua on tu.userID = tua.userID and tua.attributekey = 'allocshare'
     where tu.usertypeid in (2,3,5) and
           tu.status_id = 200
     group by tu.schoolID
     ) schools
     inner join (
     select tu.schoolID, tu.userID as teacherID, sum(cast(ifnull(tua.attributevalue,1) as unsigned)) shares
     from tbl_users tu
          inner join tbl_schools ts on ts.schoolID = tu.schoolID and ts.status_id = 200
          inner join tbl_participatingusers tpu on tpu.userid = tu.userID and tpu.awardmonth = @thismonth and tpu.participating = 1
          left join tbl_userattributes tua on tu.userID = tua.userID and tua.attributekey = 'allocshare'
     where tu.usertypeid in (2,3,5) and
           tu.status_id = 200
     group by tu.userID
     ) teachers on schools.schoolID = teachers.schoolID
     inner join (select sum(tsainner.schoolawardamount) as schoolawardamount, tsainner.schoolID from tbl_schoolawards tsainner where status_id = 200 group by tsainner.schoolID) tsa on tsa.schoolID = schools.schoolID
where
      floor(tsa.schoolawardamount / (schools.shares / teachers.shares)) > 0;


-- Take the remainder and award to the school admin

insert into tbl_teacherawards (teacherawardtypeid,
                               teacherid,
                               studentid,
                               classroomid,
                               teacherawardamount,
                               awarddate,
                               status_id,
                               createdby)
select 2,
       teachers.teacherID,
       0,
       0,
       tsa.schoolawardamount - (schools.shares * floor(tsa.schoolawardamount / (schools.shares / 1))) as adminbucks,
       @rightnow,
       200,
       0
from (
     select tu.schoolID, sum(cast(ifnull(tua.attributevalue,1) as unsigned)) shares
     from tbl_users tu
          inner join tbl_schools ts on ts.schoolID = tu.schoolID and ts.status_id = 200
          inner join tbl_participatingusers tpu on tpu.userid = tu.userID and tpu.awardmonth = @thismonth and tpu.participating = 1
          left join tbl_userattributes tua on tu.userID = tua.userID and tua.attributekey = 'allocshare'
     where tu.usertypeid in (2,3,5) and
           tu.status_id = 200
     group by tu.schoolID
     ) schools
     inner join (
     select tu.schoolID, tu.userID as teacherID, sum(cast(ifnull(tua.attributevalue,1) as unsigned)) shares
     from tbl_users tu
          inner join tbl_schools ts on ts.schoolID = tu.schoolID and ts.status_id = 200
          left join tbl_userattributes tua on tu.userID = tua.userID and tua.attributekey = 'allocshare'
     where tu.usertypeid in (3,5) and
           tu.status_id = 200
     group by tu.userID
     ) teachers on schools.schoolID = teachers.schoolID
     inner join (select sum(tsainner.schoolawardamount) as schoolawardamount, tsainner.schoolID from tbl_schoolawards tsainner where status_id = 200 group by tsainner.schoolID) tsa on tsa.schoolID = schools.schoolID
where
      (tsa.schoolawardamount - (schools.shares * floor(tsa.schoolawardamount / (schools.shares / 1)))) > 0;


-- insert a row only for schools that have non-participating teachers
insert into tbl_schoolawards (schoolID,teacherawardtypeID,schoolAwardAmount,schoolawarddate,status_id,createdby,description)
select ts.schoolID,2,count(tpu.userID) * 700 as bucks,@rightnow,200,0,concat('Monthly award for ',monthname(CURRENT_DATE),' for ',count(tpu.userID), ' non participating teachers') as description
from tbl_schools ts
     inner join tbl_users tu on ts.schoolID = tu.schoolID and tu.usertypeid in (2,3,5)
     inner join tbl_participatingusers tpu on tpu.userID = tu.userID and
                                             tpu.participating = 0 and
                                             tpu.awardmonth = @thismonth
where
     ts.status_id = 200
group by ts.schoolID;


-- Award a token amount to teachers that are not participating

insert into tbl_teacherawards (teacherawardtypeid,
                               teacherid,
                               studentid,
                               classroomid,
                               teacherawardamount,
                               awarddate,
                               status_id,
                               createdby)
select 2,
       teachers.teacherID,
       0,
       0,
       700 as teacherbucks,
       @rightnow,
       200,
       0
from  (
     select tu.schoolID, tu.userID as teacherID, sum(cast(ifnull(tua.attributevalue,1) as unsigned)) shares
     from tbl_users tu
          inner join tbl_schools ts on ts.schoolID = tu.schoolID and ts.status_id = 200
          inner join tbl_participatingusers tpu on tpu.userid = tu.userID and tpu.awardmonth = @thismonth and tpu.participating = 0
          left join tbl_userattributes tua on tu.userID = tua.userID and tua.attributekey = 'allocshare'
     where tu.usertypeid in (2,3,5) and
           tu.status_id = 200
     group by tu.userID
     ) teachers;


-- Subtract the stuff we just awarded the teachers from the school awards

insert into tbl_schoolawards (schoolID,
                              teacherawardtypeid,
                              schoolawardamount,
                              schoolawarddate,
                              status_id,
                              teacherID,
                              teacherawardID,
                              createdby,
                              description)
select tu.schoolID,3,0-tta.teacherawardamount,tta.awarddate,200,tta.teacherID,tta.teacherawardid,0,concat('Teacher Bucks allocation for ',monthname(tta.awarddate),' - ', tu.userfname, ' ', tu.userlname)
from tbl_teacherawards tta
     inner join tbl_users tu on tta.teacherID = tu.userID
     left join tbl_schoolawards tsa on tsa.teacherawardid = tta.teacherawardid and tsa.status_id = 200
where tta.awarddate = @rightnow and
      tsa.teacherawardid is null and
      tta.teacherawardtypeid = 2 and
      tta.status_id = 200;

INSERT INTO routine (routine_date) VALUES (@rightnow);
```
