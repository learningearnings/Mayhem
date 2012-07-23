# New Models

## Award
 * student\_user_id
 * otucode_id
 * amount
 * reason\_type_id
<pre><code>
     1 | Reward Redemption
     2 | Teacher Bucks Award
     3 | Auction Won
     4 | Teacher Individual Award
     5 | LearningEarnings.com Individual Award
     6 | School Administrator Individual Award
     7 | School Administrator Bucks Award
     8 | Teacher Classroom Award
     9 | LE Admin Award
    10 | Teacher E-Bucks Award
    11 | LearningEarnings.com E-Bucks Award
    12 | School Admin E-Bucks Award
    13 | LE Admin Adjust
    14 | Transfer out of Checking
    15 | Transfer into Savings
    16 | Transfer out of Savings
    17 | Transfer into Checking
    18 | LE Bucks Won from Foodfight
    19 | LE Bucks Won from Concentration
    20 | Interest Paid on Savings
</code></pre>
 * account\_type_id
 * datetime

## TeacherAllotment
 * teacher\_user_id
 * award_id (nullable - FK to awards)
 * transaction\_type_id
<pre><code>
     1 | ZeroBal
     2 | Admin Gift
     3 | Teacher Bucks Award
     4 | Teacher Individual Award
     5 | AdminOverride
     6 | Student Removed
     7 | Student Added
     8 | Teacher Classroom Award
     9 | School Admin Bucks Award
    10 | School Admin Individual Award
    11 | School Admin Created Initial Points
    12 | Teacher E-Buck Award
</code></pre>
 * amount
 * datetime

## OneTimeUseCode (otucode)
 * issuing\_user_id
 * teacher\_allotment_id
 * amount
 * expiration_date
 * redemption_date
 * ebuck (boolean y/n)

## SchoolAllotment
 * school_id
 * transaction\_type_id
 * amount
 * datetime
 * teacher\_allotment_ID (nullable - FK to teacherallotments)
 * created\_by\_user\_id (LE admin user\_id or school admin user\_id)
 * description (text description of the transaction)
<pre><code>
     "School Award for deactivated Student Kristan Stanton"
     "Teacher Bucks allocation for November - Matthew Grippin"
     "Teacher Bucks allocation for November - Luis Dominguez-Paris"
     "Teacher Bucks allocation for November - Natasha Moorer"
     "Teacher Bucks allocation for November - Sue Paitsel"
     "Teacher Bucks allocation for November - Wendy Price"
     "Monthly award for November for 38 non participating teachers"
</code></pre>
## Balance (used for calculating interest)
 * user_id
 * account\_type_id
 * amount
 * transactions (decimal)
 * transaction_count
 * startdate
 * enddate
