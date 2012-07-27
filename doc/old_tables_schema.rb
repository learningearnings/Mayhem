# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "login", :primary_key => "adminID", :force => true do |t|
    t.string  "username",         :limit => 55,  :null => false
    t.string  "password",         :limit => 55,  :null => false
    t.string  "userfname",        :limit => 55
    t.string  "userlname",        :limit => 55
    t.string  "email",            :limit => 150
    t.integer "status_id",        :limit => 2
    t.string  "facebook_account", :limit => 100
  end

  add_index "login", ["password"], :name => "password"
  add_index "login", ["status_id"], :name => "status_id"
  add_index "login", ["username"], :name => "username", :unique => true

  create_table "routine", :primary_key => "routine_id", :force => true do |t|
    t.string    "routinetype",  :limit => 30, :default => "FOM", :null => false
    t.integer   "affectedrows"
    t.integer   "insertedrows"
    t.integer   "updatedrows"
    t.integer   "deletedrows"
    t.integer   "elapsedtime",  :limit => 2
    t.date      "startdate"
    t.date      "enddate"
    t.timestamp "routine_date",                                  :null => false
  end

  create_table "tbl_adblockers", :force => true do |t|
    t.integer   "ipaddress",                        :null => false
    t.boolean   "falsepositive", :default => false, :null => false
    t.datetime  "createddate",                      :null => false
    t.timestamp "updateddate",                      :null => false
  end

  add_index "tbl_adblockers", ["ipaddress"], :name => "ad_blocker_ipaddress", :unique => true

  create_table "tbl_admin_logit", :primary_key => "logitID", :force => true do |t|
    t.integer  "logittypeID",    :null => false
    t.integer  "adminID",        :null => false
    t.string   "logitipaddress", :null => false
    t.datetime "logitDate",      :null => false
    t.integer  "userID"
    t.integer  "schoolID"
    t.integer  "partnerID"
    t.integer  "rewardID"
  end

  create_table "tbl_admin_logitdetails", :primary_key => "logitdetailID", :force => true do |t|
    t.integer "logitID",                    :null => false
    t.string  "logitdetail", :limit => 100, :null => false
  end

  add_index "tbl_admin_logitdetails", ["logitID"], :name => "index_logitID"
  add_index "tbl_admin_logitdetails", ["logitID"], :name => "logitID"

  create_table "tbl_admin_logittypes", :primary_key => "logittypeID", :force => true do |t|
    t.string  "logittype",              :null => false
    t.integer "status_id", :limit => 2
  end

  create_table "tbl_adsense_cache", :force => true do |t|
    t.string    "userkey",          :null => false
    t.text      "pagedata"
    t.timestamp "createddate",      :null => false
    t.datetime  "adsensefetchdate"
  end

  add_index "tbl_adsense_cache", ["createddate"], :name => "tac_createddate"
  add_index "tbl_adsense_cache", ["userkey"], :name => "tac_userkey"

  create_table "tbl_answers", :force => true do |t|
    t.integer "answertypeID", :limit => 2
    t.string  "answer",       :limit => 500
  end

  add_index "tbl_answers", ["answer"], :name => "ta_answers", :length => {"answer"=>333}

  create_table "tbl_auctiondetails", :primary_key => "auctiondetailID", :force => true do |t|
    t.integer  "auctionID",                       :null => false
    t.integer  "schoolID",                        :null => false
    t.integer  "schoolgradeID",                   :null => false
    t.string   "schoolmaxgradeID",                :null => false
    t.datetime "auctionshowtime",                 :null => false
    t.datetime "auctionshowendtime",              :null => false
    t.integer  "status_id",          :limit => 2
  end

  create_table "tbl_auctions", :primary_key => "auctionID", :force => true do |t|
    t.integer  "rewardID",                        :null => false
    t.string   "auctiontitle",                    :null => false
    t.string   "auctiondesc",                     :null => false
    t.string   "auctiondirection",                :null => false
    t.datetime "auctionshowtime",                 :null => false
    t.datetime "auctionshowendtime",              :null => false
    t.datetime "auctioncreated",                  :null => false
    t.datetime "auctionexpires",                  :null => false
    t.integer  "auctionwinnerbidID",              :null => false
    t.integer  "status_id",          :limit => 2
  end

  create_table "tbl_avatars", :force => true do |t|
    t.string    "name",          :limit => 1024
    t.string    "comment",       :limit => 1024
    t.string    "imagetype",     :limit => 0,    :null => false
    t.string    "imagelocation", :limit => 256,  :null => false
    t.integer   "status_id",     :limit => 2,    :null => false
    t.datetime  "createddate"
    t.timestamp "updateddate",                   :null => false
    t.integer   "sortorder",     :limit => 8
  end

  add_index "tbl_avatars", ["imagelocation"], :name => "imagelocation", :unique => true
  add_index "tbl_avatars", ["sortorder"], :name => "idx_sortorder"
  add_index "tbl_avatars", ["status_id"], :name => "status_id"

  create_table "tbl_awardreasons", :force => true do |t|
    t.string  "reason_text",                               :null => false
    t.integer "status_id",   :limit => 2, :default => 200, :null => false
    t.integer "owner_id",                 :default => 0,   :null => false
    t.integer "filterID",                 :default => 0,   :null => false
  end

  create_table "tbl_balances", :force => true do |t|
    t.integer "userID",           :limit => 8,                                                 :null => false
    t.integer "pointtypeID",      :limit => 1,                                                 :null => false
    t.decimal "balance",                       :precision => 10, :scale => 2
    t.decimal "transactions",                  :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.integer "transactioncount", :limit => 2,                                :default => 0,   :null => false
    t.date    "startdate",                                                                     :null => false
    t.date    "enddate"
  end

  add_index "tbl_balances", ["userID", "pointtypeID", "enddate"], :name => "tb_useridpointtypeenddate"
  add_index "tbl_balances", ["userID", "pointtypeID", "startdate"], :name => "tb_useridpointtypestartdate"

  create_table "tbl_billingtypes", :primary_key => "billingtypeID", :force => true do |t|
    t.string  "billingtype",              :null => false
    t.integer "status_id",   :limit => 2
  end

  create_table "tbl_boardmessages", :force => true do |t|
    t.integer   "filterID",       :limit => 8,                  :null => false
    t.text      "boardmessage",                                 :null => false
    t.datetime  "expirationdate"
    t.integer   "priority",       :limit => 2, :default => 0,   :null => false
    t.integer   "status_id",      :limit => 2, :default => 200, :null => false
    t.datetime  "createddate",                                  :null => false
    t.integer   "createdby",      :limit => 8,                  :null => false
    t.timestamp "updateddate",                                  :null => false
    t.integer   "updatedby",      :limit => 8,                  :null => false
  end

  create_table "tbl_bookmarks", :force => true do |t|
    t.integer "userID",       :limit => 8,                           :null => false
    t.string  "url",          :limit => 1024,                        :null => false
    t.text    "postdata"
    t.string  "title",        :limit => 512,                         :null => false
    t.string  "bookmarktype", :limit => 0,    :default => "History", :null => false
    t.string  "urltype",      :limit => 0,    :default => "Normal",  :null => false
    t.date    "created"
    t.time    "createdtime"
    t.string  "schedule",     :limit => 0
  end

  add_index "tbl_bookmarks", ["userID", "bookmarktype", "title"], :name => "tb_usertypetitle", :length => {"userID"=>nil, "bookmarktype"=>nil, "title"=>255}

  create_table "tbl_cachedresults", :force => true do |t|
    t.string   "md5",               :limit => 32, :null => false
    t.binary   "compressedresults",               :null => false
    t.datetime "expires"
  end

  add_index "tbl_cachedresults", ["md5"], :name => "tcr_md5unique", :unique => true

  create_table "tbl_capturedads", :force => true do |t|
    t.integer "userID",      :limit => 8,        :null => false
    t.string  "url",         :limit => 75,       :null => false
    t.text    "adhtml",      :limit => 16777215, :null => false
    t.date    "createddate",                     :null => false
    t.time    "createdtime",                     :null => false
  end

  create_table "tbl_classroomdetails", :primary_key => "classroomdetailID", :force => true do |t|
    t.integer  "classroomID",                         :null => false
    t.integer  "userID",                              :null => false
    t.datetime "classroomdetailcreated",              :null => false
    t.integer  "status_id",              :limit => 2
  end

  add_index "tbl_classroomdetails", ["classroomID"], :name => "classroomID"
  add_index "tbl_classroomdetails", ["status_id", "userID"], :name => "status_id"
  add_index "tbl_classroomdetails", ["userID"], :name => "userID"

  create_table "tbl_classrooms", :primary_key => "classroomID", :force => true do |t|
    t.integer  "userID",                                         :null => false
    t.integer  "schoolID",                                       :null => false
    t.integer  "grade",            :limit => 1
    t.string   "classroomtitle",                                 :null => false
    t.datetime "classroomcreated",                               :null => false
    t.string   "classroomRank",    :limit => 0, :default => "0", :null => false
    t.string   "studentRank",      :limit => 0, :default => "0", :null => false
    t.string   "studentName",      :limit => 0, :default => "0", :null => false
    t.integer  "status_id",        :limit => 2
  end

  add_index "tbl_classrooms", ["schoolID", "status_id"], :name => "tc_schoolstatus"
  add_index "tbl_classrooms", ["status_id"], :name => "status_id"
  add_index "tbl_classrooms", ["userID"], :name => "userID"

  create_table "tbl_concentrationgames", :force => true do |t|
    t.string   "abbr",            :limit => 50,                  :null => false
    t.string   "description"
    t.integer  "filterID",        :limit => 8,  :default => 0,   :null => false
    t.integer  "questiongroupID", :limit => 8
    t.datetime "startdate",                                      :null => false
    t.datetime "enddate"
    t.integer  "minx",            :limit => 2,  :default => 2,   :null => false
    t.integer  "miny",            :limit => 2,  :default => 2,   :null => false
    t.integer  "maxx",            :limit => 2,  :default => 7,   :null => false
    t.integer  "maxy",            :limit => 2,  :default => 7,   :null => false
    t.integer  "status_id",       :limit => 2,  :default => 200, :null => false
  end

  create_table "tbl_concentrationscores", :force => true do |t|
    t.integer   "gameID",         :limit => 8,    :null => false
    t.integer   "userID",         :limit => 8,    :null => false
    t.integer   "xsize",          :limit => 2,    :null => false
    t.integer   "ysize",          :limit => 2,    :null => false
    t.string    "questionIDs",    :limit => 2048
    t.integer   "elapsedseconds",                 :null => false
    t.timestamp "createddate",                    :null => false
  end

  create_table "tbl_don_agg_rank", :id => false, :force => true do |t|
    t.integer "userID",                                                    :null => false
    t.decimal "TSP",                        :precision => 32, :scale => 0
    t.integer "schoolid",                                                  :null => false
    t.integer "schoolgradeID",                                             :null => false
    t.integer "Rank",          :limit => 8
  end

  create_table "tbl_faqs", :primary_key => "faqID", :force => true do |t|
    t.integer "faqsort",                  :null => false
    t.string  "faqtype",                  :null => false
    t.text    "faqquestion",              :null => false
    t.text    "faqanswer",                :null => false
    t.integer "status_id",   :limit => 2
  end

  add_index "tbl_faqs", ["faqtype"], :name => "faqtype"
  add_index "tbl_faqs", ["status_id"], :name => "status_id"

  create_table "tbl_filedownload", :primary_key => "filedownloadid", :force => true do |t|
    t.string    "filename",           :limit => 50,                :null => false
    t.string    "enc_filename",                                    :null => false
    t.integer   "userid",                                          :null => false
    t.integer   "download_count",                   :default => 0, :null => false
    t.timestamp "last_download_date",                              :null => false
    t.timestamp "creation_date",                                   :null => false
    t.integer   "msg_id",                                          :null => false
  end

  create_table "tbl_filterclassrooms", :force => true do |t|
    t.integer   "filterID",    :limit => 8, :null => false
    t.integer   "classroomID", :limit => 8
    t.datetime  "createddate",              :null => false
    t.timestamp "updateddate",              :null => false
    t.integer   "createdby",   :limit => 8, :null => false
    t.integer   "updatedby",   :limit => 8, :null => false
  end

  add_index "tbl_filterclassrooms", ["filterID", "classroomID"], :name => "tfc_classroomID"

  create_table "tbl_filtermembership", :id => false, :force => true do |t|
    t.integer "userid",    :limit => 8, :null => false
    t.integer "filter_id", :limit => 8, :null => false
  end

  add_index "tbl_filtermembership", ["userid", "filter_id"], :name => "tfm_useridfilterid", :unique => true

  create_table "tbl_filters", :force => true do |t|
    t.integer   "minschoolgrade", :limit => 2,  :default => 0,  :null => false
    t.integer   "maxschoolgrade", :limit => 2,  :default => 12, :null => false
    t.datetime  "createddate",                                  :null => false
    t.timestamp "updateddate",                                  :null => false
    t.integer   "createdby",      :limit => 8,                  :null => false
    t.integer   "updatedby",      :limit => 8
    t.string    "nickname",       :limit => 50
  end

  add_index "tbl_filters", ["nickname"], :name => "tf_uniquenickname", :unique => true

  create_table "tbl_filterschools", :force => true do |t|
    t.integer   "filterID",    :limit => 8, :null => false
    t.integer   "schoolID",    :limit => 8
    t.datetime  "createddate",              :null => false
    t.timestamp "updateddate",              :null => false
    t.integer   "createdby",   :limit => 8, :null => false
    t.integer   "updatedby",   :limit => 8, :null => false
  end

  add_index "tbl_filterschools", ["filterID", "schoolID"], :name => "tfs_schoolID"

  create_table "tbl_filterstates", :force => true do |t|
    t.integer   "filterID",    :limit => 8, :null => false
    t.integer   "stateID",     :limit => 8
    t.datetime  "createddate",              :null => false
    t.timestamp "updateddate",              :null => false
    t.integer   "createdby",   :limit => 8, :null => false
    t.integer   "updatedby",   :limit => 8, :null => false
  end

  add_index "tbl_filterstates", ["filterID", "stateID"], :name => "tfs_stateID"

  create_table "tbl_filterusertypes", :force => true do |t|
    t.integer   "filterID",    :limit => 8, :null => false
    t.integer   "usertypeID",  :limit => 8
    t.datetime  "createddate",              :null => false
    t.timestamp "updateddate",              :null => false
    t.integer   "createdby",   :limit => 8, :null => false
    t.integer   "updatedby",   :limit => 8, :null => false
  end

  add_index "tbl_filterusertypes", ["filterID", "usertypeID"], :name => "tfut_usertypeID"

  create_table "tbl_foodfightrounds", :force => true do |t|
    t.string   "abbr",            :limit => 50,                :null => false
    t.string   "description",                                  :null => false
    t.integer  "filterID",        :limit => 8,  :default => 0, :null => false
    t.integer  "questiongroupID", :limit => 8
    t.datetime "startdate",                                    :null => false
    t.datetime "enddate"
  end

  create_table "tbl_foodfightuserstatistics", :force => true do |t|
    t.integer   "userID",      :limit => 8,                :null => false
    t.integer   "roundID",     :limit => 8, :default => 0, :null => false
    t.integer   "answered",    :limit => 8, :default => 0, :null => false
    t.integer   "throws",      :limit => 8, :default => 0, :null => false
    t.integer   "correct",     :limit => 8,                :null => false
    t.datetime  "createddate",                             :null => false
    t.timestamp "updateddate",                             :null => false
  end

  add_index "tbl_foodfightuserstatistics", ["userID", "roundID"], :name => "idx_tffus_userround", :unique => true

  create_table "tbl_fooditems", :force => true do |t|
    t.string    "name",        :limit => 99,                 :null => false
    t.string    "imagename",   :limit => 512,                :null => false
    t.string    "splatimage",  :limit => 512
    t.integer   "unlockcount",                :default => 0, :null => false
    t.timestamp "createddate",                               :null => false
  end

  create_table "tbl_foodthrows", :force => true do |t|
    t.integer   "roundID",      :limit => 8, :null => false
    t.integer   "userID",       :limit => 8, :null => false
    t.integer   "useranswerID", :limit => 8, :null => false
    t.integer   "fooditemID",   :limit => 8
    t.string    "targettype",   :limit => 0
    t.integer   "targetID",     :limit => 8
    t.datetime  "createddate",               :null => false
    t.timestamp "updateddate",               :null => false
  end

  add_index "tbl_foodthrows", ["fooditemID", "userID"], :name => "tft_fooditemuserid"
  add_index "tbl_foodthrows", ["targetID", "targettype"], :name => "tft_targettypetargetid"

  create_table "tbl_forgot_pwd", :force => true do |t|
    t.integer   "userID",      :limit => 8, :null => false
    t.datetime  "createddate"
    t.timestamp "updateddate",              :null => false
    t.integer   "status_id",   :limit => 2, :null => false
  end

  create_table "tbl_fun_facts", :primary_key => "facts_id", :force => true do |t|
    t.integer "status_id", :limit => 2
    t.text    "facts",                  :null => false
  end

  create_table "tbl_generatedobjects", :force => true do |t|
    t.string   "objecttype",     :limit => 0
    t.string   "generationtype", :limit => 0
    t.string   "objecturl",      :limit => 200,                  :null => false
    t.integer  "objectid",       :limit => 8,                    :null => false
    t.integer  "status_id",      :limit => 2,   :default => 200, :null => false
    t.datetime "createddate",                                    :null => false
    t.integer  "createdby",      :limit => 8,                    :null => false
  end

  create_table "tbl_help", :primary_key => "h_id", :force => true do |t|
    t.text   "h_value",   :null => false
    t.string "halp_type", :null => false
  end

  create_table "tbl_imageuploads", :force => true do |t|
    t.string  "path",         :limit => 512,                :null => false
    t.string  "originalname", :limit => 512
    t.string  "mimetype",     :limit => 20
    t.integer "width"
    t.integer "height"
    t.integer "filebytes",    :limit => 8
    t.integer "colordepth"
    t.integer "uploaderID",   :limit => 8
    t.integer "status_id",    :limit => 2,   :default => 1, :null => false
  end

  create_table "tbl_inbox_v", :id => false, :force => true do |t|
    t.integer  "msg_id",           :limit => 8,    :default => 0,  :null => false
    t.string   "inbox_flag",       :limit => 1,    :default => "", :null => false
    t.string   "msg_read_status",  :limit => 6,    :default => "", :null => false
    t.integer  "msg_to_id",        :limit => 8
    t.integer  "msg_from_id",      :limit => 8,                    :null => false
    t.string   "msg_subject",      :limit => 100,                  :null => false
    t.string   "msg_body",         :limit => 8192,                 :null => false
    t.datetime "date",                                             :null => false
    t.string   "msg_reply_status", :limit => 10,   :default => "", :null => false
    t.string   "sentbox_flag",     :limit => 1,    :default => "", :null => false
    t.integer  "msg_id_reply",     :limit => 8
    t.integer  "otu_id",           :limit => 8
  end

  create_table "tbl_localrewardcategories", :force => true do |t|
    t.string    "name",                                        :null => false
    t.integer   "rewardimageID", :limit => 8,                  :null => false
    t.integer   "status_id",     :limit => 2, :default => 200, :null => false
    t.datetime  "createddate",                                 :null => false
    t.timestamp "updateddate",                                 :null => false
    t.integer   "createdby",     :limit => 8,                  :null => false
    t.integer   "updatedby",     :limit => 8
    t.integer   "filterID",      :limit => 8, :default => 0,   :null => false
  end

  create_table "tbl_logit", :primary_key => "logitID", :force => true do |t|
    t.integer  "logittypeID",                  :null => false
    t.integer  "userID",                       :null => false
    t.integer  "schoolID",                     :null => false
    t.integer  "partnerid",                    :null => false
    t.integer  "rewardid",                     :null => false
    t.integer  "auctionid",                    :null => false
    t.string   "logitipaddress", :limit => 15, :null => false
    t.datetime "logitDate",                    :null => false
  end

  create_table "tbl_logitdetails", :primary_key => "logitdetailID", :force => true do |t|
    t.integer "logitID",                    :null => false
    t.string  "logitdetail", :limit => 100, :null => false
  end

  add_index "tbl_logitdetails", ["logitID"], :name => "logitID"

  create_table "tbl_logittypes", :primary_key => "logittypeID", :force => true do |t|
    t.string  "logittype", :limit => 40, :null => false
    t.integer "status_id", :limit => 2
  end

  add_index "tbl_logittypes", ["status_id"], :name => "status_id"

  create_table "tbl_message_bodies", :force => true do |t|
    t.integer   "filterID",    :limit => 8
    t.integer   "userID",      :limit => 8,                     :null => false
    t.string    "subject",     :limit => 100,                   :null => false
    t.string    "body",        :limit => 8192,                  :null => false
    t.integer   "otucodeID",   :limit => 8
    t.datetime  "createddate",                                  :null => false
    t.timestamp "updateddate",                                  :null => false
    t.integer   "status_id",   :limit => 2,    :default => 200, :null => false
  end

  add_index "tbl_message_bodies", ["body"], :name => "body", :length => {"body"=>333}
  add_index "tbl_message_bodies", ["filterID", "status_id"], :name => "tmb_filterID"
  add_index "tbl_message_bodies", ["otucodeID"], :name => "tmb_otucode"

  create_table "tbl_messages", :force => true do |t|
    t.integer  "messagebodyID",      :limit => 8,                  :null => false
    t.integer  "userID",             :limit => 8
    t.datetime "readdate"
    t.integer  "replymessagebodyID", :limit => 8
    t.integer  "status_id",          :limit => 2, :default => 200, :null => false
  end

  add_index "tbl_messages", ["messagebodyID", "userID"], :name => "tmb_messagebodyiduserid"
  add_index "tbl_messages", ["messagebodyID"], :name => "tm_messagebodyid"
  add_index "tbl_messages", ["userID", "status_id"], :name => "idx_messagestatususeridstatusid"

  create_table "tbl_newstuff", :primary_key => "newstuffID", :force => true do |t|
    t.string    "icon",        :limit => 95
    t.integer   "usertypeID"
    t.string    "heading",                     :default => "Heading Text Missing"
    t.string    "description", :limit => 1000, :default => "Description Text Missing"
    t.timestamp "createdate"
    t.timestamp "lastupdated"
    t.integer   "userID",                      :default => 0
    t.integer   "activate",                    :default => 1
    t.integer   "clicks",                      :default => 0
    t.integer   "thumbs",                      :default => 0
  end

  create_table "tbl_otucodereason", :force => true do |t|
    t.integer "otucodeID",     :null => false
    t.integer "awardreasonID", :null => false
  end

  create_table "tbl_otucodes", :primary_key => "otucodeID", :force => true do |t|
    t.integer  "issuinguserID",                                                                  :null => false
    t.integer  "schoolID",                                                                       :null => false
    t.integer  "ClassroomID",                                                                    :null => false
    t.integer  "redeeminguserID",                                                                :null => false
    t.string   "OTUcode",         :limit => 8,                                                   :null => false
    t.decimal  "otucodepoint",                 :precision => 10, :scale => 2, :default => 0.0,   :null => false
    t.datetime "OTUcodeexpires",                                                                 :null => false
    t.datetime "OTUcodeDate",                                                                    :null => false
    t.datetime "OTUcodeRedeemed",                                                                :null => false
    t.datetime "OTUCodePrinted",                                                                 :null => false
    t.boolean  "ebuck",                                                       :default => false, :null => false
    t.integer  "status_id",       :limit => 2
    t.integer  "TeacherAwardID",  :limit => 8
  end

  add_index "tbl_otucodes", ["OTUcode"], :name => "OTUcode", :unique => true
  add_index "tbl_otucodes", ["issuinguserID", "OTUcodeDate"], :name => "toc_otucodedate"
  add_index "tbl_otucodes", ["issuinguserID", "TeacherAwardID"], :name => "toc_teacheraward"
  add_index "tbl_otucodes", ["issuinguserID"], :name => "toc_teacherid"
  add_index "tbl_otucodes", ["redeeminguserID", "otucodeID", "OTUcodeRedeemed"], :name => "toc_userotucodeidotucoderedeemed"
  add_index "tbl_otucodes", ["redeeminguserID"], :name => "redeeminguserID"
  add_index "tbl_otucodes", ["status_id"], :name => "status_id"

  create_table "tbl_page", :primary_key => "pageID", :force => true do |t|
    t.string    "page_name",         :limit => 25,                      :null => false
    t.string    "url",               :limit => 1024
    t.string    "title",             :limit => 1024
    t.string    "description",       :limit => 1024
    t.string    "additional_header", :limit => 1024
    t.string    "page_meta_keyword",                                    :null => false
    t.string    "page_ads",          :limit => 15,                      :null => false
    t.boolean   "page_is_mirror",                    :default => false, :null => false
    t.timestamp "last_updated",                                         :null => false
    t.integer   "status_id",         :limit => 2
  end

  add_index "tbl_page", ["page_name"], :name => "page_name", :unique => true
  add_index "tbl_page", ["status_id"], :name => "status_id"

  create_table "tbl_participatingusers", :force => true do |t|
    t.integer   "userID",        :limit => 8,                   :null => false
    t.datetime  "userlastlogin",                                :null => false
    t.boolean   "participating",              :default => true, :null => false
    t.datetime  "awardmonth",                                   :null => false
    t.datetime  "createddate",                                  :null => false
    t.timestamp "updateddate",                                  :null => false
  end

  add_index "tbl_participatingusers", ["userID", "awardmonth"], :name => "tpu_useridawardmonth", :unique => true

  create_table "tbl_partnercontacts", :primary_key => "partnercontactID", :force => true do |t|
    t.integer  "partnerID",                   :null => false
    t.string   "contactfname",                :null => false
    t.string   "contactlname",                :null => false
    t.string   "contactemail",                :null => false
    t.string   "contactphone",                :null => false
    t.datetime "contactcreated",              :null => false
    t.integer  "status_id",      :limit => 2
  end

  add_index "tbl_partnercontacts", ["partnerID"], :name => "partnerID"
  add_index "tbl_partnercontacts", ["status_id"], :name => "status_id"

  create_table "tbl_partners", :primary_key => "partnerID", :force => true do |t|
    t.integer  "billingtypeID",                 :null => false
    t.string   "partner",                       :null => false
    t.string   "username",                      :null => false
    t.string   "partneraddress",                :null => false
    t.string   "stateID",                       :null => false
    t.string   "cityID",                        :null => false
    t.string   "zipcode",                       :null => false
    t.string   "phone"
    t.datetime "partnercreated",                :null => false
    t.string   "partner_password",              :null => false
    t.datetime "partnerlastlogin",              :null => false
    t.integer  "status_id",        :limit => 2
  end

  add_index "tbl_partners", ["status_id"], :name => "status_id"

  create_table "tbl_patterndetails", :force => true do |t|
    t.integer   "rewardpatternID",       :limit => 8,                    :null => false
    t.integer   "parentpatterndetailID", :limit => 8
    t.integer   "rewardID",              :limit => 8,                    :null => false
    t.integer   "minschoolgrade",        :limit => 2, :default => 0,     :null => false
    t.integer   "maxschoolgrade",        :limit => 2, :default => 12,    :null => false
    t.integer   "basecount",             :limit => 2,                    :null => false
    t.integer   "status_id",             :limit => 2,                    :null => false
    t.integer   "createdby",             :limit => 8,                    :null => false
    t.integer   "updatedby",             :limit => 8
    t.datetime  "createddate"
    t.timestamp "updateddate",                                           :null => false
    t.boolean   "lockupdates",                        :default => false, :null => false
  end

  add_index "tbl_patterndetails", ["rewardpatternID", "parentpatterndetailID"], :name => "idsParent", :unique => true
  add_index "tbl_patterndetails", ["rewardpatternID", "rewardID", "basecount", "status_id"], :name => "tpd_rewardpatternrewardbasecountstatus"
  add_index "tbl_patterndetails", ["rewardpatternID"], :name => "idxRewardPattern"

  create_table "tbl_pointactions", :primary_key => "pointactionID", :force => true do |t|
    t.string  "pointaction",     :limit => 40,                   :null => false
    t.string  "transaction_dir", :limit => 0,  :default => "IN", :null => false
    t.integer "status_id",       :limit => 2
  end

  add_index "tbl_pointactions", ["status_id"], :name => "status_id"
  add_index "tbl_pointactions", ["transaction_dir"], :name => "transaction_dir"

  create_table "tbl_points", :primary_key => "pointID", :force => true do |t|
    t.integer  "pointtypeID",                                                 :null => false
    t.integer  "userID",                                                      :null => false
    t.integer  "schoolID",                                                    :null => false
    t.integer  "ClassroomID",                                                 :null => false
    t.integer  "pointactionID",                                               :null => false
    t.integer  "rewardID",                                                    :null => false
    t.integer  "otucodeID"
    t.decimal  "points",                       :precision => 10, :scale => 2
    t.datetime "pointtimestamp",                                              :null => false
    t.integer  "rewardauctionID", :limit => 8
    t.integer  "teacherID",       :limit => 8
  end

  add_index "tbl_points", ["pointID", "rewardID"], :name => "tp_rewardpointtimestamp"
  add_index "tbl_points", ["pointtimestamp"], :name => "tp_pointtimestamp"
  add_index "tbl_points", ["pointtypeID", "otucodeID"], :name => "pointtypeID_2", :unique => true
  add_index "tbl_points", ["pointtypeID"], :name => "pointtypeID"
  add_index "tbl_points", ["rewardID", "schoolID", "userID", "points"], :name => "tp_rewardschooluser"
  add_index "tbl_points", ["userID", "otucodeID", "pointtypeID"], :name => "tp_userotucodeidpointtype"
  add_index "tbl_points", ["userID", "pointtypeID"], :name => "user_pointtype"
  add_index "tbl_points", ["userID", "rewardauctionID", "rewardID"], :name => "ids_userauctionreward"
  add_index "tbl_points", ["userID"], :name => "userID"

  create_table "tbl_pointtypes", :primary_key => "pointtypeID", :force => true do |t|
    t.string  "pointtype",              :null => false
    t.integer "status_id", :limit => 2
  end

  add_index "tbl_pointtypes", ["status_id"], :name => "status_id"

  create_table "tbl_poll_answers", :primary_key => "answerid", :force => true do |t|
    t.integer "pollid", :limit => 8,                  :null => false
    t.string  "answer", :limit => 512,                :null => false
    t.integer "count",  :limit => 8,   :default => 0
  end

  create_table "tbl_poll_participants", :primary_key => "participantID", :force => true do |t|
    t.integer   "pollID",      :limit => 8, :null => false
    t.integer   "userid",                   :null => false
    t.integer   "answerID",    :limit => 8, :null => false
    t.timestamp "createddate",              :null => false
  end

  create_table "tbl_polls", :primary_key => "pollid", :force => true do |t|
    t.string   "question",    :limit => 2048,                  :null => false
    t.datetime "startdate",                                    :null => false
    t.datetime "enddate",                                      :null => false
    t.datetime "createddate",                                  :null => false
    t.integer  "createdby",   :limit => 8,                     :null => false
    t.datetime "updateddate"
    t.integer  "updatedby",   :limit => 8
    t.integer  "status_id",   :limit => 2,    :default => 200
    t.integer  "filterID",    :limit => 8,    :default => 0,   :null => false
  end

  create_table "tbl_qatypes", :force => true do |t|
    t.string  "abbr",        :limit => 50,                  :null => false
    t.string  "description"
    t.integer "status_id",   :limit => 2,  :default => 200, :null => false
  end

  create_table "tbl_questionanswers", :force => true do |t|
    t.integer "questionID", :limit => 8,                    :null => false
    t.integer "answerID",   :limit => 8,                    :null => false
    t.boolean "correct",                 :default => false, :null => false
    t.integer "status_id",  :limit => 2, :default => 200,   :null => false
  end

  add_index "tbl_questionanswers", ["answerID"], :name => "idx_tqa_answerid"
  add_index "tbl_questionanswers", ["questionID", "answerID"], :name => "idx_tqa_questionidanswerid"

  create_table "tbl_questioncategories", :force => true do |t|
    t.string  "subject",   :limit => 50,                  :null => false
    t.string  "category"
    t.integer "status_id", :limit => 2,  :default => 200, :null => false
  end

  create_table "tbl_questiongroups", :force => true do |t|
    t.string  "abbr",        :limit => 50,                          :null => false
    t.string  "description"
    t.integer "teacherID",   :limit => 8
    t.integer "filterID",    :limit => 8,  :default => 0,           :null => false
    t.integer "status_id",   :limit => 2,  :default => 200,         :null => false
    t.string  "gametype",    :limit => 0,  :default => "FoodFight", :null => false
  end

  create_table "tbl_questions", :force => true do |t|
    t.integer   "questiontypeID",     :limit => 2,                            :null => false
    t.integer   "questioncategoryID", :limit => 2,                            :null => false
    t.integer   "numanswers",         :limit => 2,   :default => 4,           :null => false
    t.integer   "grade",              :limit => 2
    t.string    "question",           :limit => 500
    t.integer   "approvalcount",                     :default => 0,           :null => false
    t.datetime  "createddate",                                                :null => false
    t.timestamp "updateddate",                                                :null => false
    t.integer   "teacherID",          :limit => 8
    t.integer   "createdby",          :limit => 8,                            :null => false
    t.integer   "updatedby",          :limit => 8,                            :null => false
    t.integer   "status_id",          :limit => 2,   :default => 200,         :null => false
    t.string    "gametype",           :limit => 0,   :default => "FoodFight", :null => false
  end

  add_index "tbl_questions", ["question"], :name => "tq_question", :length => {"question"=>333}

  create_table "tbl_questiontogroup", :force => true do |t|
    t.integer   "questionID",      :limit => 8,                  :null => false
    t.integer   "questiongroupID", :limit => 8,                  :null => false
    t.timestamp "createddate",                                   :null => false
    t.integer   "status_id",       :limit => 2, :default => 200, :null => false
  end

  add_index "tbl_questiontogroup", ["questiongroupID", "questionID"], :name => "tqtg_groupgquestion"

  create_table "tbl_ratings", :force => true do |t|
    t.integer   "userID",      :limit => 8,                       :null => false
    t.string    "ratingtype",  :limit => 0,    :default => "URL", :null => false
    t.string    "campaign",    :limit => 100,                     :null => false
    t.string    "subject",     :limit => 100,                     :null => false
    t.string    "answers",     :limit => 2048,                    :null => false
    t.string    "comment",     :limit => 2048,                    :null => false
    t.datetime  "createddate",                                    :null => false
    t.timestamp "updateddate",                                    :null => false
    t.integer   "status_id",   :limit => 2,    :default => 200,   :null => false
  end

  create_table "tbl_recipients", :force => true do |t|
    t.integer  "vgoodID",     :limit => 8, :null => false
    t.integer  "userID",      :limit => 8, :null => false
    t.datetime "createddate",              :null => false
  end

  create_table "tbl_redeemed", :primary_key => "redeemedID", :force => true do |t|
    t.integer  "rewardID",                                        :null => false
    t.integer  "rewarddetailID",                   :default => 0, :null => false
    t.integer  "rewardglobalID",                   :default => 0, :null => false
    t.string   "description"
    t.integer  "rewardlocalID",       :limit => 8
    t.integer  "pointID",             :limit => 8
    t.integer  "redeemedbyuserID",                                :null => false
    t.integer  "redeemedClassroomID",                             :null => false
    t.datetime "rewardredeemDate",                                :null => false
    t.integer  "redeemedTeacherID",   :limit => 8
  end

  add_index "tbl_redeemed", ["pointID"], :name => "pointID", :unique => true
  add_index "tbl_redeemed", ["redeemedbyuserID"], :name => "redeemedbyuserID"
  add_index "tbl_redeemed", ["rewardID"], :name => "rewardID"

  create_table "tbl_rewardauctionbids", :force => true do |t|
    t.integer   "rewardauctionID",      :limit => 8,                                                  :null => false
    t.integer   "userID",               :limit => 8,                                                  :null => false
    t.integer   "totalbids",            :limit => 8,                                 :default => 1,   :null => false
    t.datetime  "firstbiddate",                                                                       :null => false
    t.timestamp "lastbiddate",                                                                        :null => false
    t.decimal   "currentbidamount",                   :precision => 10, :scale => 2
    t.integer   "captcha_count",        :limit => 2,                                 :default => 0,   :null => false
    t.datetime  "captcha_time"
    t.integer   "auction_plays",        :limit => 8,                                 :default => 0,   :null => false
    t.integer   "captcha_target_plays", :limit => 8,                                 :default => 100, :null => false
    t.string    "captcha_string",       :limit => 10
    t.string    "buyitnowprice",        :limit => 10
  end

  add_index "tbl_rewardauctionbids", ["rewardauctionID", "lastbiddate"], :name => "trab_auctionidlastbiddate"
  add_index "tbl_rewardauctionbids", ["rewardauctionID", "totalbids"], :name => "trab_auctionidtotalbids"
  add_index "tbl_rewardauctionbids", ["rewardauctionID", "userID"], :name => "AuctionID_UserID", :unique => true
  add_index "tbl_rewardauctionbids", ["rewardauctionID"], :name => "trab_auctionid"

  create_table "tbl_rewardauctions", :force => true do |t|
    t.integer   "parentrewardauctionID", :limit => 8
    t.string    "name",                                                                                       :null => false
    t.text      "description"
    t.integer   "rewardID",              :limit => 8,                                                         :null => false
    t.string    "auctiontype",           :limit => 0,                                :default => "Race",      :null => false
    t.integer   "reservebids",           :limit => 8,                                :default => 0,           :null => false
    t.datetime  "startdate",                                                                                  :null => false
    t.datetime  "enddate",                                                                                    :null => false
    t.datetime  "countdowndate"
    t.integer   "countdownminutes",      :limit => 2,                                :default => 30
    t.string    "renewtype",             :limit => 0,                                :default => "Automatic", :null => false
    t.string    "confirmation",          :limit => 0,                                :default => "Automatic", :null => false
    t.integer   "rolloverbidspercent",   :limit => 1,                                :default => 50,          :null => false
    t.integer   "lebidsmarginpercent",   :limit => 1,                                :default => 15,          :null => false
    t.integer   "winneruserID",          :limit => 8
    t.string    "lockguid"
    t.integer   "lockuserID",            :limit => 8
    t.integer   "status_id",             :limit => 2,                                                         :null => false
    t.datetime  "createddate",                                                                                :null => false
    t.timestamp "updateddate",                                                                                :null => false
    t.integer   "createdby",             :limit => 8,                                                         :null => false
    t.integer   "updatedby",             :limit => 8
    t.integer   "filterID",              :limit => 8,                                :default => 0,           :null => false
    t.decimal   "bininitialprice",                    :precision => 10, :scale => 2
    t.decimal   "maxbinbalance",                      :precision => 10, :scale => 2
  end

  add_index "tbl_rewardauctions", ["countdowndate", "status_id", "auctiontype"], :name => "tra_countdownstatustype"
  add_index "tbl_rewardauctions", ["filterID"], :name => "tra_filterID"
  add_index "tbl_rewardauctions", ["id", "status_id"], :name => "tra_idstatusid"
  add_index "tbl_rewardauctions", ["rewardID", "filterID", "status_id"], :name => "tra_rewardidfilteridstatusid"

  create_table "tbl_rewardcategories", :primary_key => "rewardcategoryID", :force => true do |t|
    t.integer "usertype",                     :null => false
    t.string  "rewardcategory", :limit => 30, :null => false
    t.integer "status_id",      :limit => 2
  end

  create_table "tbl_rewardcertificates", :force => true do |t|
    t.integer   "pointID",     :limit => 8,                     :null => false
    t.integer   "downloads",   :limit => 2,    :default => 0,   :null => false
    t.string    "cert_parms",  :limit => 2048
    t.integer   "status_id",   :limit => 2,    :default => 200, :null => false
    t.timestamp "createddate",                                  :null => false
  end

  create_table "tbl_rewarddeliveries", :primary_key => "pointID", :force => true do |t|
    t.integer  "deliveryteacherID", :limit => 8,                  :null => false
    t.datetime "deliverydate"
    t.datetime "createddate"
    t.integer  "status_id",         :limit => 2, :default => 200, :null => false
  end

  add_index "tbl_rewarddeliveries", ["deliveryteacherID", "deliverydate"], :name => "trd_teacherdate"

  create_table "tbl_rewarddetails", :primary_key => "rewarddetailID", :force => true do |t|
    t.integer "rewardID",                    :null => false
    t.integer "stateID",                     :null => false
    t.integer "schoolID",                    :null => false
    t.integer "min_grade",      :limit => 1
    t.integer "max_grade",      :limit => 1
    t.integer "rewardquantity",              :null => false
    t.integer "status_id",      :limit => 2
  end

  add_index "tbl_rewarddetails", ["max_grade"], :name => "max_grade"
  add_index "tbl_rewarddetails", ["min_grade"], :name => "min_grade"
  add_index "tbl_rewarddetails", ["rewardID"], :name => "rewardID"
  add_index "tbl_rewarddetails", ["schoolID", "rewardID"], :name => "trd_schoolrewardid"
  add_index "tbl_rewarddetails", ["schoolID"], :name => "schoolID"
  add_index "tbl_rewarddetails", ["status_id"], :name => "status_id"

  create_table "tbl_rewardglobals", :primary_key => "rewardglobalID", :force => true do |t|
    t.integer "rewardID",                                     :null => false
    t.integer "rewardquantity",              :default => 0,   :null => false
    t.integer "status_id",      :limit => 2, :default => 200, :null => false
    t.integer "filterID",       :limit => 8, :default => 0,   :null => false
  end

  add_index "tbl_rewardglobals", ["filterID", "rewardID", "status_id"], :name => "trg_filterrewardidstatus"
  add_index "tbl_rewardglobals", ["rewardID"], :name => "rewardID"
  add_index "tbl_rewardglobals", ["status_id"], :name => "status_id"

  create_table "tbl_rewardimages", :force => true do |t|
    t.string    "imagepath",                :null => false
    t.datetime  "createddate",              :null => false
    t.timestamp "updateddate",              :null => false
    t.integer   "createdby",   :limit => 8, :null => false
    t.integer   "updatedby",   :limit => 8
  end

  create_table "tbl_rewardlocals", :force => true do |t|
    t.integer   "rewardID",              :limit => 8,                  :null => false
    t.string    "name",                                                :null => false
    t.integer   "pointtypeID",           :limit => 8, :default => 1,   :null => false
    t.integer   "localrewardcategoryID", :limit => 8,                  :null => false
    t.integer   "points",                :limit => 8, :default => 1,   :null => false
    t.integer   "quantity",              :limit => 8, :default => 1,   :null => false
    t.integer   "quantityredeemed",      :limit => 8, :default => 0,   :null => false
    t.integer   "lowinventory",          :limit => 8, :default => 0,   :null => false
    t.integer   "rewardimageID",         :limit => 8
    t.string    "headertext"
    t.string    "body"
    t.string    "footertext"
    t.integer   "userID",                :limit => 8,                  :null => false
    t.integer   "filterID",              :limit => 8,                  :null => false
    t.integer   "status_id",             :limit => 2, :default => 200, :null => false
    t.datetime  "createddate",                                         :null => false
    t.timestamp "updateddate",                                         :null => false
    t.integer   "createdby",             :limit => 8,                  :null => false
  end

  add_index "tbl_rewardlocals", ["filterID"], :name => "trlr_filterid"
  add_index "tbl_rewardlocals", ["rewardID"], :name => "trlr_rewardid"

  create_table "tbl_rewardpatterns", :force => true do |t|
    t.string    "name",            :limit => 1024
    t.string    "comment",         :limit => 1024
    t.integer   "parentpatternID", :limit => 8
    t.integer   "schoolID",        :limit => 8
    t.integer   "status_id",       :limit => 2,    :null => false
    t.integer   "createdby",       :limit => 8,    :null => false
    t.integer   "updatedby",       :limit => 8
    t.datetime  "createddate"
    t.timestamp "updateddate",                     :null => false
  end

  add_index "tbl_rewardpatterns", ["parentpatternID", "schoolID"], :name => "idxParent"
  add_index "tbl_rewardpatterns", ["status_id", "schoolID"], :name => "trp_statusschool"

  create_table "tbl_rewards", :primary_key => "rewardID", :force => true do |t|
    t.integer  "partnerID",                                         :null => false
    t.string   "rewardtitle",                                       :null => false
    t.integer  "rewardcategoryID",                                  :null => false
    t.string   "rewarddesc",                                        :null => false
    t.string   "rewarddirections",                                  :null => false
    t.integer  "rewardpoints",                                      :null => false
    t.integer  "rewardbonuspoints",                                 :null => false
    t.string   "rewardimagepath",                                   :null => false
    t.string   "markupfile"
    t.datetime "rewardcreated",                                     :null => false
    t.datetime "rewardexpires",                                     :null => false
    t.integer  "rewardusertype",                                    :null => false
    t.integer  "rewardstyleID",                                     :null => false
    t.boolean  "rewardhasglobal",                :default => false, :null => false
    t.integer  "numberofrewards",                                   :null => false
    t.boolean  "reward_feature",                 :default => false, :null => false
    t.boolean  "rewardauction",                  :default => false, :null => false
    t.integer  "status_id",         :limit => 2
    t.integer  "shipmentmin",                    :default => 1,     :null => false
    t.integer  "shipmentmax",                    :default => 100,   :null => false
    t.integer  "grosscount",                     :default => 1,     :null => false
    t.string   "rewardpdfpath",                                     :null => false
    t.boolean  "fohview",                        :default => false, :null => false
  end

  add_index "tbl_rewards", ["rewardcategoryID", "status_id", "rewardexpires", "rewardtitle"], :name => "tr_statusexpirescategory"
  add_index "tbl_rewards", ["status_id"], :name => "tr_statusID"

  create_table "tbl_rewardshipmentdetails", :force => true do |t|
    t.integer   "rewardshipmentID",  :limit => 8,                :null => false
    t.integer   "patterndetailID",   :limit => 8
    t.integer   "rewardID",          :limit => 8,                :null => false
    t.integer   "minschoolgrade",    :limit => 2,                :null => false
    t.integer   "maxschoolgrade",    :limit => 2,                :null => false
    t.integer   "classroomstudents",                             :null => false
    t.integer   "rewardcount",       :limit => 8,                :null => false
    t.integer   "rewardgross",       :limit => 8,                :null => false
    t.integer   "grosscount",        :limit => 8,                :null => false
    t.integer   "partialgrosscount", :limit => 8,                :null => false
    t.integer   "status_id",         :limit => 2,                :null => false
    t.integer   "createdby",         :limit => 8,                :null => false
    t.integer   "updatedby",         :limit => 8
    t.datetime  "createddate"
    t.timestamp "updateddate",                                   :null => false
    t.integer   "originalcount",     :limit => 8, :default => 0, :null => false
  end

  add_index "tbl_rewardshipmentdetails", ["rewardshipmentID", "rewardID"], :name => "shipmentID_rewardID", :unique => true

  create_table "tbl_rewardshipments", :force => true do |t|
    t.integer   "rewardpatternID", :limit => 8, :null => false
    t.integer   "status_id",       :limit => 2, :null => false
    t.integer   "schoolID",        :limit => 8, :null => false
    t.integer   "schooladdressID", :limit => 8, :null => false
    t.integer   "createdby",       :limit => 8, :null => false
    t.integer   "updatedby",       :limit => 8
    t.datetime  "createddate"
    t.timestamp "updateddate",                  :null => false
  end

  add_index "tbl_rewardshipments", ["createddate", "schoolID"], :name => "trs_createddateschoolid"
  add_index "tbl_rewardshipments", ["status_id", "schoolID"], :name => "trs_statusschoolid"

  create_table "tbl_rewardstyle", :primary_key => "rewardstyleID", :force => true do |t|
    t.string  "rewardstyle",              :null => false
    t.integer "status_id",   :limit => 2
  end

  add_index "tbl_rewardstyle", ["status_id"], :name => "status_id"

  create_table "tbl_rewardsuggestions", :primary_key => "rewardsuggestionID", :force => true do |t|
    t.string   "rewardsuggestion",                  :null => false
    t.integer  "userID",                            :null => false
    t.integer  "schoolID",                          :null => false
    t.datetime "rewardsuggestionDate",              :null => false
    t.integer  "status_id",            :limit => 2
  end

  add_index "tbl_rewardsuggestions", ["schoolID"], :name => "schoolID"
  add_index "tbl_rewardsuggestions", ["status_id"], :name => "status_id"
  add_index "tbl_rewardsuggestions", ["userID"], :name => "userID"

  create_table "tbl_roundanswers", :force => true do |t|
    t.integer "roundID",      :limit => 8,                :null => false
    t.integer "useranswerID", :limit => 8,                :null => false
    t.integer "cnt",          :limit => 2, :default => 1, :null => false
  end

  add_index "tbl_roundanswers", ["roundID", "useranswerID"], :name => "idx_tra_roundiduseranswerid", :unique => true

  create_table "tbl_routeconfirms", :force => true do |t|
    t.integer   "route_id",                 :null => false
    t.integer   "userID",      :limit => 8, :null => false
    t.timestamp "requiredate",              :null => false
    t.timestamp "confirmdate",              :null => false
    t.integer   "status_id",   :limit => 2, :null => false
  end

  add_index "tbl_routeconfirms", ["route_id"], :name => "route_id"
  add_index "tbl_routeconfirms", ["status_id"], :name => "status_id"
  add_index "tbl_routeconfirms", ["userID"], :name => "userID"

  create_table "tbl_routes", :force => true do |t|
    t.string  "name",      :limit => 100, :null => false
    t.string  "criteria"
    t.string  "redirect",                 :null => false
    t.integer "status_id", :limit => 2,   :null => false
  end

  add_index "tbl_routes", ["status_id"], :name => "status_id"

  create_table "tbl_school_ips", :force => true do |t|
    t.integer "schoolID",     :limit => 8,                 :null => false
    t.integer "logincount",   :limit => 8,  :default => 0, :null => false
    t.integer "ipv4_address"
    t.string  "ipv6_address", :limit => 45
    t.date    "createddate",                               :null => false
    t.date    "updateddate",                               :null => false
  end

  add_index "tbl_school_ips", ["ipv4_address", "schoolID"], :name => "tsi_schoolv4", :unique => true
  add_index "tbl_school_ips", ["ipv6_address", "schoolID"], :name => "tsi_schoolv6", :unique => true

  create_table "tbl_schooladmindetails", :primary_key => "schooladmindetailID", :force => true do |t|
    t.integer  "userID",                                :null => false
    t.integer  "schoolID",                              :null => false
    t.datetime "schooladmindetailcreated",              :null => false
    t.integer  "status_id",                :limit => 2
  end

  add_index "tbl_schooladmindetails", ["status_id"], :name => "status_id"
  add_index "tbl_schooladmindetails", ["userID"], :name => "userID"

  create_table "tbl_schoolawards", :force => true do |t|
    t.integer  "schoolID",                                           :null => false
    t.integer  "teacherawardtypeID",                                 :null => false
    t.integer  "schoolAwardAmount",                                  :null => false
    t.datetime "schoolawarddate",                                    :null => false
    t.integer  "status_id",          :limit => 2,   :default => 200, :null => false
    t.integer  "teacherID",          :limit => 8
    t.integer  "teacherawardID",     :limit => 8
    t.integer  "createdby",          :limit => 8,                    :null => false
    t.string   "description",        :limit => 512
  end

  add_index "tbl_schoolawards", ["status_id"], :name => "status_id"
  add_index "tbl_schoolawards", ["teacherawardID"], :name => "tsa_teacherawardid", :unique => true

  create_table "tbl_schoolchange", :force => true do |t|
    t.integer   "currentschoolid",                               :null => false
    t.integer   "newschoolid",                                   :null => false
    t.integer   "userID",                                        :null => false
    t.string    "reasontochange",                                :null => false
    t.text      "other",                                         :null => false
    t.datetime  "datetime",                                      :null => false
    t.timestamp "completed_date"
    t.integer   "status_id",       :limit => 2, :default => 200, :null => false
  end

  create_table "tbl_schooldetails", :primary_key => "schooldetailID", :force => true do |t|
    t.integer "schoolID",                      :null => false
    t.integer "schoolcalendarID",              :null => false
    t.integer "grade",            :limit => 1
    t.string  "schoolyear",       :limit => 5, :null => false
    t.date    "schoolfirstday",                :null => false
    t.date    "schoollastday",                 :null => false
    t.integer "status_id",        :limit => 2
  end

  create_table "tbl_schoolgrades", :primary_key => "schoolgradeID", :force => true do |t|
    t.integer "schoolgrade", :limit => 1, :null => false
    t.string  "display",     :limit => 2, :null => false
    t.integer "status_id",   :limit => 2
  end

  add_index "tbl_schoolgrades", ["status_id"], :name => "status_id"

  create_table "tbl_schoolimages", :force => true do |t|
    t.integer  "imageuploadID",   :limit => 8,                           :null => false
    t.string   "imagetype",       :limit => 0, :default => "SchoolLogo", :null => false
    t.integer  "schoolID",        :limit => 8,                           :null => false
    t.integer  "status_id",       :limit => 2, :default => 1,            :null => false
    t.integer  "adminapproverID", :limit => 8
    t.datetime "approveddate"
  end

  create_table "tbl_schools", :primary_key => "schoolID", :force => true do |t|
    t.integer   "schooltypeID",                                                                                 :null => false
    t.string    "school",                                                                                       :null => false
    t.integer   "min_grade",          :limit => 1
    t.integer   "max_grade",          :limit => 1
    t.string    "schooladdress",                                                                                :null => false
    t.string    "schooladdress2"
    t.string    "cityID",                                                                                       :null => false
    t.string    "stateID",                                                                                      :null => false
    t.string    "schoolzip",                                                                                    :null => false
    t.string    "schoolphone",                                                                                  :null => false
    t.string    "schoolmailto",                                                                                 :null => false
    t.string    "logo_path",          :limit => 60
    t.string    "mascot_name",        :limit => 30
    t.boolean   "schooldemo",                                                        :default => false,         :null => false
    t.timestamp "createdate",                                                                                   :null => false
    t.integer   "status_id",          :limit => 2
    t.decimal   "lat",                               :precision => 18, :scale => 12
    t.decimal   "lon",                               :precision => 18, :scale => 12
    t.integer   "pnt",                :limit => nil,                                                            :null => false
    t.string    "timezone",           :limit => 50
    t.decimal   "gmtoffset",                         :precision => 5,  :scale => 0
    t.string    "distribution_model", :limit => 0,                                   :default => "Centralized", :null => false
    t.integer   "ad_profile",         :limit => 1,                                   :default => 1
  end

  add_index "tbl_schools", ["pnt"], :name => "ts_location", :length => {"pnt"=>32}
  add_index "tbl_schools", ["schooltypeID"], :name => "schooltypeID"
  add_index "tbl_schools", ["stateID"], :name => "ts_stateid"
  add_index "tbl_schools", ["status_id"], :name => "status_id"

  create_table "tbl_schooltypes", :primary_key => "schooltypeID", :force => true do |t|
    t.string  "schooltype", :limit => 20, :null => false
    t.integer "status_id",  :limit => 2
  end

  add_index "tbl_schooltypes", ["status_id"], :name => "status_id"

  create_table "tbl_schoolyear", :primary_key => "school_yearID", :force => true do |t|
    t.string  "school_year",   :limit => 10,                     :null => false
    t.string  "school_status", :limit => 5,  :default => "true", :null => false
    t.integer "status_id",     :limit => 2
  end

  create_table "tbl_scrollingmessages", :force => true do |t|
    t.integer   "filterID",       :limit => 8,                        :null => false
    t.string    "loggedin",       :limit => 0,    :default => "No",   :null => false
    t.string    "format",         :limit => 0,    :default => "Tile", :null => false
    t.string    "message",        :limit => 2000,                     :null => false
    t.string    "author1",        :limit => 200
    t.string    "author2",        :limit => 200
    t.integer   "displayseconds", :limit => 1,    :default => 20,     :null => false
    t.datetime  "createddate",                                        :null => false
    t.timestamp "updateddate",                                        :null => false
    t.integer   "createdby",      :limit => 8,                        :null => false
    t.integer   "updatedby",      :limit => 8,                        :null => false
  end

  create_table "tbl_scrollingmessageviews", :force => true do |t|
    t.integer "userID",             :limit => 8,                :null => false
    t.date    "viewdate",                                       :null => false
    t.integer "scrollingmessageID", :limit => 8,                :null => false
    t.integer "views",              :limit => 8, :default => 0, :null => false
  end

  add_index "tbl_scrollingmessageviews", ["userID", "scrollingmessageID", "viewdate"], :name => "tsmv_useridmessageiddate", :unique => true

  create_table "tbl_searchterms", :force => true do |t|
    t.integer   "itemID",       :limit => 8, :null => false
    t.integer   "itemfilterID", :limit => 8, :null => false
    t.string    "itemtype",     :limit => 0
    t.text      "itemtext",                  :null => false
    t.timestamp "updateddate",               :null => false
  end

  add_index "tbl_searchterms", ["itemtext"], :name => "tst_search"

  create_table "tbl_sessions", :primary_key => "session_id", :force => true do |t|
    t.string  "ip_address",    :limit => 16,  :default => "0", :null => false
    t.string  "user_agent",    :limit => 120, :default => "0", :null => false
    t.integer "last_activity",                :default => 0,   :null => false
    t.text    "user_data",                                     :null => false
  end

  add_index "tbl_sessions", ["last_activity"], :name => "last_activity_idx"

  create_table "tbl_socialaccounts", :force => true do |t|
    t.integer "userID",      :limit => 8,                     :null => false
    t.string  "accounttype", :limit => 0
    t.string  "accountid",   :limit => 100
    t.string  "permissions", :limit => 5000
    t.integer "status_id",   :limit => 2,    :default => 200, :null => false
  end

  add_index "tbl_socialaccounts", ["accountid", "accounttype", "status_id"], :name => "tsa_accountidaccounttype"
  add_index "tbl_socialaccounts", ["userID", "accounttype", "status_id"], :name => "tsa_useridaccounttype"

  create_table "tbl_socialconnections", :force => true do |t|
    t.integer "userID",                :limit => 8, :null => false
    t.integer "frienduserID",          :limit => 8, :null => false
    t.integer "usersocialaccountID",   :limit => 8, :null => false
    t.integer "friendsocialaccountID", :limit => 8, :null => false
  end

  add_index "tbl_socialconnections", ["userID", "frienduserID"], :name => "tsc_useridfriendid", :unique => true

  create_table "tbl_socialposthits", :primary_key => "socialpostID", :force => true do |t|
    t.integer "hits", :limit => 8, :default => 0, :null => false
  end

  create_table "tbl_socialposts", :force => true do |t|
    t.integer "userID",          :limit => 8,                      :null => false
    t.integer "socialaccountID", :limit => 8,                      :null => false
    t.string  "uuid",            :limit => 23,                     :null => false
    t.string  "le_publicURL",    :limit => 1000
    t.string  "le_privateURL",   :limit => 1000
    t.string  "accountpostURL",  :limit => 1000
    t.string  "accountpostData", :limit => 10000
    t.integer "status_id",       :limit => 2,     :default => 200, :null => false
    t.date    "createddate",                                       :null => false
    t.time    "createdtime",                                       :null => false
  end

  create_table "tbl_socialschoolposts", :force => true do |t|
    t.integer "socialschoolID", :limit => 8,                     :null => false
    t.string  "postby",         :limit => 0
    t.integer "posterID",       :limit => 8
    t.string  "accountpostURL", :limit => 1000
    t.integer "status_id",      :limit => 2,    :default => 200, :null => false
    t.date    "createddate",                                     :null => false
    t.time    "createdtime",                                     :null => false
  end

  create_table "tbl_socialschools", :force => true do |t|
    t.integer   "schoolID",       :limit => 8,                   :null => false
    t.string    "accounttype",    :limit => 0
    t.string    "accountsubtype", :limit => 0
    t.integer   "lesubtypeid",    :limit => 8
    t.string    "accountID",      :limit => 100
    t.string    "accountname",    :limit => 500
    t.string    "accounturl",     :limit => 1000
    t.string    "permissions",    :limit => 5000
    t.integer   "status_id",      :limit => 2,    :default => 1, :null => false
    t.integer   "createdby",      :limit => 8,                   :null => false
    t.datetime  "createddate",                                   :null => false
    t.timestamp "updateddate",                                   :null => false
  end

  add_index "tbl_socialschools", ["schoolID", "accountID", "accounttype"], :name => "tss_schoolaccountaccounttype", :unique => true

  create_table "tbl_socialschoolverifications", :force => true do |t|
    t.integer "socialschoolID", :limit => 8,                :null => false
    t.integer "adminID",        :limit => 8
    t.integer "status_id",      :limit => 2, :default => 1, :null => false
  end

  create_table "tbl_states", :primary_key => "stateID", :force => true do |t|
    t.string "state",     :limit => 20, :null => false
    t.string "StateAbbr", :limit => 2,  :null => false
    t.string "showstate", :limit => 5,  :null => false
  end

  create_table "tbl_status_types", :force => true do |t|
    t.string  "status_type",                               :null => false
    t.string  "status_type_description",                   :null => false
    t.boolean "status_active",           :default => true, :null => false
  end

  create_table "tbl_sticky_messages", :force => true do |t|
    t.integer   "messagebodyID",      :limit => 8,                         :null => false
    t.string    "schedule",           :limit => 0, :default => "Weekdays", :null => false
    t.boolean   "sendtoeveryone",                  :default => false,      :null => false
    t.datetime  "proposedsenddate"
    t.datetime  "actualsenddate"
    t.integer   "proposedrecipients", :limit => 8
    t.integer   "actualrecipients",   :limit => 8
    t.integer   "status_id",          :limit => 2, :default => 100,        :null => false
    t.integer   "approvedby",         :limit => 8
    t.datetime  "approveddate"
    t.datetime  "createddate",                                             :null => false
    t.timestamp "updateddate",                                             :null => false
  end

  add_index "tbl_sticky_messages", ["messagebodyID", "status_id"], :name => "tsm_messagebodyidstatusid"

  create_table "tbl_student_facts", :primary_key => "student_facts_id", :force => true do |t|
    t.integer "status_id", :limit => 2
    t.integer "facts_id",               :null => false
    t.integer "user_id",                :null => false
  end

  create_table "tbl_studentdetails", :primary_key => "studentdetailID", :force => true do |t|
    t.integer  "userID",                            :null => false
    t.integer  "schoolID",                          :null => false
    t.integer  "grade",                :limit => 1
    t.datetime "studentdetailcreated",              :null => false
    t.integer  "status_id",            :limit => 2
  end

  add_index "tbl_studentdetails", ["userID"], :name => "userID"

  create_table "tbl_studentreporting", :primary_key => "userID", :force => true do |t|
    t.date    "recruitmentvalid"
    t.integer "recruitmentvalid_yearweek"
  end

  add_index "tbl_studentreporting", ["recruitmentvalid"], :name => "tsr_recruitmentvalid"
  add_index "tbl_studentreporting", ["recruitmentvalid_yearweek"], :name => "tsr_recruitmentyearweek"

  create_table "tbl_suggestion_types", :primary_key => "suggestiontypeid", :force => true do |t|
    t.string "suggestiontype", :null => false
  end

  create_table "tbl_suggestions", :primary_key => "suggestionid", :force => true do |t|
    t.text     "suggestion",                                     :null => false
    t.integer  "userid",                                         :null => false
    t.integer  "schoolid",                                       :null => false
    t.integer  "suggestiontypeid",                               :null => false
    t.string   "suggestionlocation"
    t.datetime "createddate",                                    :null => false
    t.datetime "updateddate"
    t.integer  "updatedby",          :limit => 8
    t.integer  "status_id",          :limit => 2, :default => 1
  end

  add_index "tbl_suggestions", ["schoolid"], :name => "schoolid"
  add_index "tbl_suggestions", ["suggestiontypeid"], :name => "suggestiontypeid"
  add_index "tbl_suggestions", ["userid"], :name => "userid"

  create_table "tbl_systemconfig", :force => true do |t|
    t.string    "attributekey",                   :null => false
    t.string    "attributevalue", :limit => 4096
    t.datetime  "startdate"
    t.datetime  "enddate"
    t.datetime  "createddate",                    :null => false
    t.timestamp "updateddate",                    :null => false
  end

  add_index "tbl_systemconfig", ["attributekey"], :name => "tsc_attributekey"

  create_table "tbl_taggedobjects", :force => true do |t|
    t.integer "tagID",      :limit => 8, :null => false
    t.integer "objectID",   :limit => 8, :null => false
    t.string  "objecttype", :limit => 0
  end

  add_index "tbl_taggedobjects", ["objecttype", "objectID"], :name => "tto_objecttypeobjectid"

  create_table "tbl_tags", :force => true do |t|
    t.string    "tag",         :limit => 50,                :null => false
    t.string    "pluraltag",   :limit => 50,                :null => false
    t.string    "tagtype",     :limit => 0
    t.datetime  "createddate",                              :null => false
    t.integer   "createdby",   :limit => 8,                 :null => false
    t.timestamp "updateddate",                              :null => false
    t.integer   "updatedby",   :limit => 8,                 :null => false
    t.integer   "status_id",   :limit => 2,  :default => 1, :null => false
  end

  create_table "tbl_teacherawards", :primary_key => "TeacherAwardID", :force => true do |t|
    t.integer  "TeacherAwardTypeID",                               :null => false
    t.integer  "TeacherID",                                        :null => false
    t.integer  "StudentID",                                        :null => false
    t.integer  "ClassroomID",                                      :null => false
    t.integer  "TeacherAwardAmount",                               :null => false
    t.datetime "AwardDate",                                        :null => false
    t.integer  "status_id",          :limit => 2, :default => 200, :null => false
    t.integer  "createdby",          :limit => 8,                  :null => false
    t.integer  "filedownloadid",     :limit => 8
  end

  add_index "tbl_teacherawards", ["ClassroomID"], :name => "ClassroomID"
  add_index "tbl_teacherawards", ["TeacherAwardTypeID"], :name => "TeacherAwardTypeID"
  add_index "tbl_teacherawards", ["TeacherID"], :name => "TeacherID"

  create_table "tbl_teacherawardtype", :primary_key => "TeacherAwardTypeID", :force => true do |t|
    t.string  "TeacherAwardType",         :limit => 40,                    :null => false
    t.string  "transaction_dir",          :limit => 0,  :default => "IN",  :null => false
    t.boolean "TeacherAwardTypeinactive",               :default => false, :null => false
    t.integer "status_id",                :limit => 2
  end

  add_index "tbl_teacherawardtype", ["status_id"], :name => "status_id"
  add_index "tbl_teacherawardtype", ["transaction_dir"], :name => "transaction_dir"

  create_table "tbl_teacherdetails", :primary_key => "teacherdetailID", :force => true do |t|
    t.integer  "userID",                            :null => false
    t.integer  "schoolID",                          :null => false
    t.integer  "grade",                :limit => 1
    t.datetime "teacherdetailcreated",              :null => false
    t.integer  "status_id",            :limit => 2
  end

  create_table "tbl_terms", :primary_key => "terms_id", :force => true do |t|
    t.text "terms", :null => false
  end

  create_table "tbl_tips", :force => true do |t|
    t.string    "url",          :limit => 1024,                          :null => false
    t.string    "tip",          :limit => 50,                            :null => false
    t.integer   "displayorder", :limit => 1
    t.string    "helptext",     :limit => 2048
    t.string    "tipposition",  :limit => 0,    :default => "topMiddle", :null => false
    t.integer   "status_id",    :limit => 2,    :default => 1,           :null => false
    t.datetime  "createddate",                                           :null => false
    t.timestamp "updateddate",                                           :null => false
  end

  create_table "tbl_tracking", :force => true do |t|
    t.integer "userID"
    t.string  "page",                                             :null => false
    t.date    "created"
    t.integer "ipaddress",                         :default => 0, :null => false
    t.time    "createdtime"
    t.integer "elapsed_milliseconds", :limit => 2, :default => 0, :null => false
    t.integer "memory_usage_kb",      :limit => 2, :default => 0, :null => false
  end

  add_index "tbl_tracking", ["created", "userID", "createdtime"], :name => "tt_useridcreated"
  add_index "tbl_tracking", ["created"], :name => "created"
  add_index "tbl_tracking", ["ipaddress"], :name => "tt_ipaddress"
  add_index "tbl_tracking", ["userID", "ipaddress", "created"], :name => "tt_useripcreated"
  add_index "tbl_tracking", ["userID"], :name => "userID"

  create_table "tbl_trophycase", :force => true do |t|
    t.integer   "stateID",        :limit => 8
    t.integer   "grade",          :limit => 2
    t.integer   "schoolID",       :limit => 8
    t.string    "trophyposition", :limit => 0
    t.integer   "userID",         :limit => 8
    t.datetime  "createddate",                 :null => false
    t.timestamp "updateddate",                 :null => false
  end

  add_index "tbl_trophycase", ["stateID", "schoolID", "grade"], :name => "ttc_stateschoolgrade"
  add_index "tbl_trophycase", ["trophyposition", "stateID", "schoolID", "grade"], :name => "trophyposition", :unique => true
  add_index "tbl_trophycase", ["userID"], :name => "userID"

  create_table "tbl_trophycaseblacklists", :primary_key => "userID", :force => true do |t|
    t.string "why"
  end

  create_table "tbl_useranswers", :force => true do |t|
    t.integer   "userID",         :limit => 8,                :null => false
    t.integer   "questionID",     :limit => 8,                :null => false
    t.integer   "answerID",       :limit => 8,                :null => false
    t.integer   "cnt",            :limit => 2, :default => 1, :null => false
    t.integer   "elapsedseconds"
    t.datetime  "createddate",                                :null => false
    t.timestamp "updateddate",                                :null => false
  end

  add_index "tbl_useranswers", ["questionID", "answerID"], :name => "idx_tua_questionidanswerid"
  add_index "tbl_useranswers", ["userID", "questionID", "answerID"], :name => "idx_tua_useridquestionidanswerid", :unique => true

  create_table "tbl_userattributes", :force => true do |t|
    t.integer   "userID",         :limit => 8,                     :null => false
    t.string    "attributekey",                                    :null => false
    t.string    "attributevalue", :limit => 4096
    t.datetime  "createddate"
    t.timestamp "updateddate",                                     :null => false
    t.integer   "status_id",      :limit => 2,    :default => 200, :null => false
  end

  add_index "tbl_userattributes", ["userID", "attributekey"], :name => "userID", :unique => true

  create_table "tbl_useravatars", :force => true do |t|
    t.string    "displayname", :limit => 50
    t.integer   "userID",      :limit => 8,  :null => false
    t.integer   "avatarID",    :limit => 2
    t.integer   "status_id",   :limit => 2,  :null => false
    t.datetime  "createddate"
    t.timestamp "updateddate",               :null => false
  end

  add_index "tbl_useravatars", ["avatarID", "status_id"], :name => "tua_avatarstatus"
  add_index "tbl_useravatars", ["status_id"], :name => "status_id"
  add_index "tbl_useravatars", ["userID"], :name => "userID"

  create_table "tbl_users", :primary_key => "userID", :force => true do |t|
    t.integer  "schoolID",                        :default => 0, :null => false
    t.integer  "grade",            :limit => 1
    t.integer  "usertypeID",                                     :null => false
    t.string   "username",         :limit => 65,                 :null => false
    t.string   "usergender",       :limit => 0
    t.string   "usersalutation",   :limit => 0
    t.string   "useremail",        :limit => 65
    t.string   "userpass",         :limit => 32,                 :null => false
    t.string   "userfname",        :limit => 50,                 :null => false
    t.string   "userlname",        :limit => 50,                 :null => false
    t.date     "dateofbirth"
    t.integer  "stateID",                                        :null => false
    t.string   "zipcode",          :limit => 5,                  :null => false
    t.datetime "usercreated",                                    :null => false
    t.string   "verificationcode", :limit => 25
    t.datetime "verificationDate"
    t.datetime "userlastlogin"
    t.string   "userlastloginip",  :limit => 15
    t.integer  "status_id",        :limit => 2
    t.integer  "point_bal",                       :default => 0, :null => false
    t.integer  "virtual_bal",                     :default => 0, :null => false
    t.integer  "new_msgs",         :limit => 2,   :default => 0, :null => false
    t.string   "facebookID",       :limit => 100
    t.string   "recoverypassword", :limit => 100
  end

  add_index "tbl_users", ["facebookID"], :name => "tu_facebookid", :unique => true
  add_index "tbl_users", ["schoolID"], :name => "schoolID"
  add_index "tbl_users", ["status_id", "grade", "userID"], :name => "tu_grade"
  add_index "tbl_users", ["status_id", "usertypeID", "schoolID", "userlastlogin"], :name => "tu_statususertypeschoollogin"
  add_index "tbl_users", ["status_id"], :name => "status_id"
  add_index "tbl_users", ["username", "schoolID", "status_id"], :name => "username", :unique => true
  add_index "tbl_users", ["userpass"], :name => "userpass"
  add_index "tbl_users", ["usertypeID"], :name => "usertypeID"

  create_table "tbl_usertypes", :primary_key => "usertypeID", :force => true do |t|
    t.string  "usertype",  :limit => 30, :null => false
    t.integer "status_id", :limit => 2
  end

  add_index "tbl_usertypes", ["status_id"], :name => "status_id"

  create_table "tbl_verified", :primary_key => "verifyID", :force => true do |t|
    t.integer  "usertypeID",     :null => false
    t.string   "verify_email",   :null => false
    t.datetime "verify_created", :null => false
    t.integer  "verify_userID",  :null => false
    t.datetime "verify_used",    :null => false
  end

  create_table "tbl_vgoodproperties", :force => true do |t|
    t.integer "vgoodID",       :limit => 8,    :null => false
    t.string  "propertykey",   :limit => 25,   :null => false
    t.string  "propertyvalue", :limit => 2000, :null => false
  end

  create_table "tbl_vgoods", :force => true do |t|
    t.integer  "parentvgoodID", :limit => 8
    t.integer  "fromuserID",    :limit => 8, :null => false
    t.integer  "vgoodimageID",  :limit => 8
    t.integer  "vgoodtypeID",   :limit => 8, :null => false
    t.integer  "points",        :limit => 8, :null => false
    t.integer  "status_id",     :limit => 2, :null => false
    t.datetime "createddate",                :null => false
  end

  create_table "tbl_vgoodtypes", :force => true do |t|
    t.boolean   "systemonly",                                                     :default => false, :null => false
    t.string    "abbreviation",    :limit => 20,                                                     :null => false
    t.string    "description",     :limit => 2000,                                                   :null => false
    t.string    "keywords",                                                                          :null => false
    t.string    "image",           :limit => 512
    t.decimal   "points",                          :precision => 10, :scale => 2
    t.decimal   "recipientpoints",                 :precision => 10, :scale => 2
    t.integer   "maxrecipients",   :limit => 8,                                   :default => 5,     :null => false
    t.integer   "minschoolgrade",  :limit => 2,                                   :default => 0,     :null => false
    t.integer   "maxschoolgrade",  :limit => 2,                                   :default => 12,    :null => false
    t.integer   "stateID",         :limit => 8,                                   :default => 0,     :null => false
    t.integer   "schoolID",        :limit => 8,                                   :default => 0,     :null => false
    t.integer   "classroomID",     :limit => 8,                                   :default => 0,     :null => false
    t.integer   "status_id",       :limit => 2,                                   :default => 200,   :null => false
    t.datetime  "createddate",                                                                       :null => false
    t.timestamp "updateddate",                                                                       :null => false
    t.integer   "createdby",       :limit => 8,                                                      :null => false
    t.integer   "updatedby",       :limit => 8
  end

  create_table "tbl_vmessageimages", :force => true do |t|
    t.string  "image",     :limit => 512
    t.integer "status_id", :limit => 2,   :default => 200, :null => false
  end

  create_table "tbl_vmessagetexts", :force => true do |t|
    t.string  "message",        :limit => 512
    t.integer "minschoolgrade", :limit => 2,   :default => 0,   :null => false
    t.integer "maxschoolgrade", :limit => 2,   :default => 12,  :null => false
    t.integer "stateID",        :limit => 8
    t.integer "schoolID",       :limit => 8,   :default => 0,   :null => false
    t.integer "classroomID",    :limit => 8,   :default => 0,   :null => false
    t.integer "status_id",      :limit => 2,   :default => 200, :null => false
  end

  create_table "tbl_vtextimagesuggestions", :force => true do |t|
    t.integer "vmessagetextID",  :limit => 8,                  :null => false
    t.integer "vmessageimageID", :limit => 8,                  :null => false
    t.integer "sortkey",         :limit => 2, :default => 0,   :null => false
    t.integer "status_id",       :limit => 2, :default => 200, :null => false
  end

  add_index "tbl_vtextimagesuggestions", ["vmessageimageID", "vmessagetextID"], :name => "tvtis_vmessageimagetextid"

  create_table "tbl_waiting", :primary_key => "w_id", :force => true do |t|
    t.string    "w_rtype",  :limit => 30, :null => false
    t.string    "w_f_name",               :null => false
    t.string    "w_l_name",               :null => false
    t.string    "w_e_mail",               :null => false
    t.string    "w_school",               :null => false
    t.string    "w_city",                 :null => false
    t.string    "w_state",                :null => false
    t.text      "w_info"
    t.timestamp "created",                :null => false
  end

  add_index "tbl_waiting", ["created"], :name => "created"

  create_table "tbl_words", :primary_key => "wordID", :force => true do |t|
    t.integer "wordtypeID",               :null => false
    t.string  "word",       :limit => 10, :null => false
    t.integer "status_id",  :limit => 2
  end

  add_index "tbl_words", ["status_id"], :name => "status_id"
  add_index "tbl_words", ["wordtypeID"], :name => "wordtypeID"

  create_table "tbl_wordtypes", :primary_key => "wordtypeID", :force => true do |t|
    t.string  "wordtype",  :limit => 25, :null => false
    t.integer "status_id", :limit => 2
  end

  add_index "tbl_wordtypes", ["status_id"], :name => "status_id"

  create_table "tmp_custom_pwds", :id => false, :force => true do |t|
    t.string "username", :limit => 65, :null => false
    t.string "pwd",      :limit => 32, :null => false
  end

  create_table "tmp_custom_usernames", :id => false, :force => true do |t|
    t.string "old_username", :limit => 65, :null => false
    t.string "new_username", :limit => 65, :null => false
  end

  create_table "tmp_don_stdstat_schagg", :id => false, :force => true do |t|
    t.integer "Rank",        :limit => 8
    t.integer "schoolid",                                                :default => 0, :null => false
    t.string  "SCHOOL_NAME",                                                            :null => false
    t.decimal "TSP",                      :precision => 32, :scale => 0
    t.integer "TAS",         :limit => 8
    t.integer "TADS",        :limit => 8
    t.decimal "AVERAGE",                  :precision => 36, :scale => 4
  end

  create_table "tmp_import_staging", :force => true do |t|
    t.integer   "usertypeID", :limit => 1
    t.integer   "schoolID",                 :null => false
    t.string    "grade",      :limit => 50
    t.string    "userfname",  :limit => 50
    t.string    "userlname",  :limit => 50
    t.string    "username",   :limit => 50
    t.string    "usergender", :limit => 6
    t.string    "useremail",  :limit => 50
    t.string    "orig_data"
    t.string    "orig_uname"
    t.timestamp "createdate",               :null => false
  end

end
