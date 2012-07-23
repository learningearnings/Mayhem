# Exising LE Tables

## FoodFight / Concentration / Games
 * tbl\_questionanswers
 * tbl\_questioncategories
 * tbl\_questiongroups
 * tbl\_questions
 * tbl\_questiontogroup
 * tbl\_answers
 * tbl\_concentrationgames
 * tbl\_concentrationscores
 * tbl\_foodfightrounds
 * tbl\_foodfightuserstatistics
 * tbl\_fooditems
 * tbl\_foodthrows
 * tbl\_useranswers
 * tbl\_poll\_answers
 * tbl\_poll\_participants
 * tbl\_polls
 * tbl\_roundanswers
 * tbl\_qatypes

## Auctions
 * tbl\_rewardauctionbids
 * tbl\_rewardauctions

## Student Avatars
 * tbl\_avatars
 * tbl\_useravatars


## LE Bucks
 * tbl\_awardreasons
 * tbl\_balances
 * tbl\_schoolawards
 * tbl\_teacherawards
 * tbl\_teacherawardtype
 * tbl\_pointactions
 * tbl\_points
 * tbl\_pointtypes
 * tbl\_filedownload
 * tbl\_otucodereason
 * tbl\_otucodes
 * tbl\_redeemed



## Web History
 * tbl\_bookmarks
 * tbl\_tracking

## Classrooms
 * tbl\_classroomdetails
 * tbl\_classrooms

## Filters (kindof like scopes - need to discuss)
 * tbl\_filterclassrooms
 * tbl\_filtermembership
 * tbl\_filters
 * tbl\_filterschools
 * tbl\_filterstates
 * tbl\_filterusertypes

## Rewards
 * tbl\_localrewardcategories
 * tbl\_rewardcategories
 * tbl\_rewardcertificates
 * tbl\_rewarddeliveries
 * tbl\_rewarddetails
 * tbl\_rewardglobals
 * tbl\_rewardimages
 * tbl\_rewardlocals
 * tbl\_rewardpatterns
 * tbl\_rewards
 * tbl\_rewardshipmentdetails
 * tbl\_rewardshipments
 * tbl\_rewardstyle
 * tbl\_rewardsuggestions
 * tbl\_newstuff

## Messages
 * tbl\_recipients
 * tbl\_message\_bodies
 * tbl\_messages
 * tbl\_vgoodproperties
 * tbl\_vgoods
 * tbl\_vgoodtypes
 * tbl\_vmessageimages
 * tbl\_vmessagetexts
 * tbl\_vtextimagesuggestions
 * tbl\_sticky\_messages
 * tbl\_suggestion\_types
 * tbl\_suggestions

## Social Media
 * tbl\_socialaccounts
 * tbl\_socialconnections
 * tbl\_socialposthits
 * tbl\_socialposts
 * tbl\_socialschoolposts
 * tbl\_socialschools
 * tbl\_socialschoolverifications

## Other
 * tbl\_boardmessages
 * tbl\_generatedobjects
 * tbl\_trophycase
 * tbl\_trophycaseblacklists
 * tbl\_tips
 * tbl\_taggedobjects
 * tbl\_tags
 * tbl\_words
 * tbl\_wordtypes
 * tbl\_routeconfirms
 * tbl\_routes
 * tbl\_faqs
 * tbl\_status\_types
 * tmp\_import\_staging
 * tmp\_custom\_pwds
 * tmp\_custom\_usernames
 * tbl\_imageuploads
 * tbl\_states
 * tbl\_waiting

## Students, Teachers and Schools
 * tbl\_userattributes
 * tbl\_users
<pre><code>
+------------------+--------------------------------+------+-----+---------+----------------+
| Field            | Type                           | Null | Key | Default | Extra          |
+------------------+--------------------------------+------+-----+---------+----------------+
| userID           | bigint(11)                     | NO   | PRI | NULL    | auto_increment |
| schoolID         | int(11)                        | NO   | MUL | 0       |                |
| grade            | tinyint(4)                     | YES  |     | NULL    |                |
| usertypeID       | int(11)                        | NO   | MUL | NULL    |                |
| username         | varchar(65)                    | NO   | MUL | NULL    |                |
| usergender       | enum('Male','Female')          | YES  |     | NULL    |                |
| usersalutation   | enum('Mr.','Mrs.','Ms.','Dr.') | YES  |     | NULL    |                |
| useremail        | varchar(65)                    | YES  |     | NULL    |                |
| userpass         | varchar(32)                    | NO   | MUL | NULL    |                |
| userfname        | varchar(50)                    | NO   |     | NULL    |                |
| userlname        | varchar(50)                    | NO   |     | NULL    |                |
| dateofbirth      | date                           | YES  |     | NULL    |                |
| stateID          | int(2)                         | NO   |     | NULL    |                |
| zipcode          | varchar(5)                     | NO   |     | NULL    |                |
| usercreated      | datetime                       | NO   |     | NULL    |                |
| verificationcode | varchar(25)                    | YES  |     | NULL    |                |
| verificationDate | datetime                       | YES  |     | NULL    |                |
| userlastlogin    | datetime                       | YES  |     | NULL    |                |
| userlastloginip  | varchar(15)                    | YES  |     | NULL    |                |
| status\_id        | smallint(5) unsigned           | YES  | MUL | NULL    |                |
| point_bal        | int(11)                        | NO   |     | 0       |                |
| virtual\_bal      | int(11)                        | NO   |     | 0       |                |
| new\_msgs         | smallint(5) unsigned           | NO   |     | 0       |                |
| facebookID       | varchar(100)                   | YES  | UNI | NULL    |                |
| recoverypassword | varchar(100)                   | YES  |     | NULL    |                |
+------------------+--------------------------------+------+-----+---------+----------------+
</code></pre>
 * tbl\_usertypes
<pre><code>
+------------+----------------------+-----------+
| usertypeID | usertype             | status_id |
+------------+----------------------+-----------+
|          1 | Student              |       200 |
|          2 | Teacher              |       200 |
|          3 | Admin                |       200 |
|          4 | Partner              |       400 |
|          5 | School Administrator |       400 |
|          6 | Sales Demo           |       200 |
|          7 | PBIS Recruitment     |       400 |
|          8 | School Recruitment   |       400 |
|          9 | Marketing Agency     |       400 |
|         10 | Corporate Sales      |       400 |
|         11 | LE Demo              |       400 |
+------------+----------------------+-----------+
</code></pre>
 * tbl\_verified
 * tbl\_participatingusers
 * tbl\_school\_ips
 * tbl\_schoolchange
 * tbl\_schoolimages
 * tbl\_schools
 <pre><code>
+--------------------+-----------------------------------+------+-----+-------------------+----------------+
| Field              | Type                              | Null | Key | Default           | Extra          |
+--------------------+-----------------------------------+------+-----+-------------------+----------------+
| schoolID           | int(11)                           | NO   | PRI | NULL              | auto_increment |
| schooltypeID       | int(11)                           | NO   | MUL | NULL              |                |
| school             | varchar(255)                      | NO   |     | NULL              |                |
| min\_grade          | tinyint(4)                        | YES  |     | NULL              |                |
| max\_grade          | tinyint(4)                        | YES  |     | NULL              |                |
| schooladdress      | varchar(255)                      | NO   |     | NULL              |                |
| schooladdress2     | varchar(255)                      | YES  |     | NULL              |                |
| cityID             | varchar(255)                      | NO   |     | NULL              |                |
| stateID            | varchar(255)                      | NO   | MUL | NULL              |                |
| schoolzip          | varchar(255)                      | NO   |     | NULL              |                |
| schoolphone        | varchar(255)                      | NO   |     | NULL              |                |
| schoolmailto       | varchar(255)                      | NO   |     | NULL              |                |
| logo\_path          | varchar(60)                       | YES  |     | NULL              |                |
| mascot_name        | varchar(30)                       | YES  |     | NULL              |                |
| schooldemo         | tinyint(1)                        | NO   |     | 0                 |                |
| createdate         | timestamp                         | NO   |     | CURRENT\_TIMESTAMP |                |
| status_id          | smallint(5) unsigned              | YES  | MUL | NULL              |                |
| lat                | decimal(18,12)                    | YES  |     | NULL              |                |
| lon                | decimal(18,12)                    | YES  |     | NULL              |                |
| pnt                | point                             | NO   | MUL | NULL              |                |
| timezone           | varchar(50)                       | YES  |     | NULL              |                |
| gmtoffset          | decimal(5,0)                      | YES  |     | NULL              |                |
| distribution\_model | enum('Centralized','Distributed') | NO   |     | Centralized       |                |
| ad_profile         | tinyint(4)                        | YES  |     | 1                 |                |
+--------------------+-----------------------------------+------+-----+-------------------+----------------+
</code></pre>
 * tbl\_studentreporting

## Advertising related
 * tbl\_page
 * tbl\_adsense\_cache (need to talk about this one)
<pre><code>
+------------------+--------------+------+-----+-------------------+-----------------------------+
| Field            | Type         | Null | Key | Default           | Extra                       |
+------------------+--------------+------+-----+-------------------+-----------------------------+
| id               | bigint(11)   | NO   | PRI | NULL              | auto\_increment              |
| userkey          | varchar(255) | NO   | MUL | NULL              |                             |
| pagedata         | text         | YES  |     | NULL              |                             |
| createddate      | timestamp    | NO   | MUL | CURRENT\_TIMESTAMP | on update CURRENT\_TIMESTAMP |
| adsensefetchdate | datetime     | YES  |     | NULL              |                             |
+------------------+--------------+------+-----+-------------------+-----------------------------+
</code></pre>
 * tbl\_adblockers (??)

## Tables that go away
 * login (goes away)
 * routine (goes away)
 * tbl\_admin\_logit (goes away)
 * tbl\_admin\_logitdetails (goes away)
 * tbl\_admin\_logittypes (goes away)
 * tbl\_auctions
 * tbl\_auctiondetails
 * tbl\_billingtypes
 * tbl\_scrollingmessages
 * tbl\_scrollingmessageviews
 * tbl\_schooladmindetails
 * tbl\_schooldetails
 * tbl\_schoolgrades
 * tbl\_schooltypes
 * tbl\_schoolyear
 * tbl\_cachedresults
 * tbl\_student\_facts
 * tbl\_studentdetails
 * tbl\_teacherdetails
 * tbl\_terms
 * tbl\_logit
 * tbl\_logitdetails
 * tbl\_logittypes
 * tbl\_systemconfig
 * tbl\_inbox\_v  (VIEW)
 * tbl\_forgot\_pwd
 * tbl\_help
 * tbl\_capturedads
 * tbl\_don\_agg\_rank
 * tbl\_fun\_facts
 * tbl\_partnercontacts
 * tbl\_partners
 * tbl\_patterndetails
 * tbl\_ratings
 * tbl\_searchterms
 * tbl\_sessions
 * tmp\_don\_stdstat\_schagg
