class PeopleImporter < ImporterBase

  def header_mapping
    {
      first_name: 'userfname',
      last_name: 'userlname',
      dob: 'dateofbirth',
      grade: 'grade'
    }
  end

  def model_class row=''
    case row[3]
    when '1'
      Student
    when '2'
      Teacher
    when '3'
      LeAdmin
    else
      nil
    end
  end
end
#userID,schoolID,grade,usertypeID,"username","usergender","usersalutation","useremail","userpass","userfname","userlname","dateofbirth",stateID,"zipcode","usercreated","verificationcode","verificationDate","userlastlogin","userlastloginip",status_id,point_bal,virtual_bal,new_msgs,"recoverypassword"
#544,98,2,3,"adam@learningearnings.com","Male","Mr.","adam@learningearnings.com","0d107d09f5bbe40cade3de5c71e9e9b7","School","Teacher","2011-08-09",1,"35810","2009-09-22 01:34:55","NgCqDahzxcr8zC7p","2009-09-22 13:36:08","2012-07-17 17:05:17",NULL,200,0,0,0,"letmein"
#576,79,6,1,"PJohnson","Female",NULL,NULL,"595075c153b484cff64fed62ba31338b","P","J",NULL,1,"35217","2009-09-23 08:09:29",NULL,NULL,"2009-10-01 11:18:53",NULL,303,0,0,0,NULL
#575,79,6,1,"BGressman","Female",NULL,NULL,"51eec98c4c441201ae312788f98aedb4","B","G",NULL,1,"35217","2009-09-23 08:09:10",NULL,NULL,"2009-12-06 09:23:06",NULL,303,0,0,0,NULL
#574,79,6,1,"HDouglas","Female",NULL,NULL,"7c42928ddec63300e497c1b5ebcc7c68","H","D",NULL,1,"35217","2009-09-23 08:09:55",NULL,NULL,"2009-12-03 10:59:05",NULL,303,0,0,0,NULL
#549,97,9,1,"apearson","Male",NULL,NULL,"e10adc3949ba59abbe56e057f20f883e","Adam","P",NULL,1,"35217","2009-09-22 05:09:58",NULL,NULL,"2009-10-12 21:42:40",NULL,200,0,0,0,NULL
#573,79,6,1,"SDoss","Female",NULL,NULL,"c21dfe87222c45a9048f562de824a42f","S","D",NULL,1,"35217","2009-09-23 08:09:36",NULL,NULL,"2009-09-23 08:09:36",NULL,303,0,0,0,NULL
#551,98,5,2,"ninademo","Female","Dr.","nina@learningearnings.com","a65cb78bb812c5b08e45766fc4c521cc","Nina","Pearson","1957-04-25",1,"35802","2009-09-22 08:20:23","S6zHi8i1DxGE1BIo","2009-09-22 20:31:05","2011-11-27 17:23:42",NULL,200,0,0,0,NULL
#572,79,6,1,"KCollins","Female",NULL,NULL,"493d7a427d6667f75515675ee7ac4afd","K","C",NULL,1,"35217","2009-09-23 08:09:19",NULL,NULL,"2009-11-19 11:04:38",NULL,303,0,0,0,NULL
#571,79,6,1,"AColeman","Female",NULL,NULL,"09b4b23b6bd518ff0f759f28886e402f","A","C",NULL,1,"35217","2009-09-23 08:09:59",NULL,NULL,"2009-12-04 10:53:03",NULL,303,0,0,0,NULL
