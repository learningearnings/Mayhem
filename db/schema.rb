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

ActiveRecord::Schema.define(:version => 20161005095435) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "zip"
    t.string   "type"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "state_id"
  end

  add_index "addresses", ["addressable_id"], :name => "index_addresses_on_addressable_id"
  add_index "addresses", ["addressable_type"], :name => "index_addresses_on_addressable_type"
  add_index "addresses", ["type"], :name => "index_addresses_on_type"

  create_table "auction_bids", :force => true do |t|
    t.integer  "person_id"
    t.integer  "auction_id"
    t.decimal  "amount",     :precision => 10, :scale => 2
    t.string   "status"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "auction_school_links", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "school_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "auction_state_links", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "auction_zip_codes", :force => true do |t|
    t.integer  "auction_id"
    t.string   "zip_code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "auctions", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal  "current_bid",     :precision => 10, :scale => 2
    t.integer  "product_id"
    t.string   "auction_type"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
    t.decimal  "starting_bid",    :precision => 10, :scale => 2
    t.integer  "min_grade",                                      :default => 0
    t.integer  "max_grade",                                      :default => 12
    t.boolean  "created_locally"
    t.boolean  "notified",                                       :default => false
    t.boolean  "fulfilled",                                      :default => false
    t.integer  "person_id"
    t.boolean  "canceled"
    t.datetime "deleted_at"
    t.string   "status"
  end

  create_table "audit_logs", :force => true do |t|
    t.integer  "person_id"
    t.integer  "log_event_id"
    t.string   "log_event_type"
    t.string   "action"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "district_guid"
    t.integer  "school_id"
    t.integer  "school_sti_id"
    t.integer  "person_sti_id"
    t.string   "person_name"
    t.string   "person_type"
    t.string   "log_event_name"
  end

  add_index "audit_logs", ["district_guid"], :name => "index_audit_logs_on_district_guid"
  add_index "audit_logs", ["log_event_name"], :name => "index_audit_logs_on_log_event_name"
  add_index "audit_logs", ["log_event_type"], :name => "index_audit_logs_on_log_event_type"
  add_index "audit_logs", ["person_id"], :name => "index_audit_logs_on_person_id"
  add_index "audit_logs", ["school_id"], :name => "index_audit_logs_on_school_id"

  create_table "avatars", :force => true do |t|
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "description"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "teacher_only", :default => false
  end

  create_table "buck_batch_links", :force => true do |t|
    t.integer  "otu_code_id"
    t.integer  "buck_batch_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "buck_batches", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "processed"
  end

  create_table "campaign_views", :force => true do |t|
    t.integer  "person_id"
    t.integer  "campaign_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.date     "eff_date"
    t.date     "exp_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "classroom_filter_links", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "filter_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "classroom_filter_links", ["filter_id", "classroom_id"], :name => "index_classroom_filter_links_on_filter_id_and_classroom_id", :unique => true

  create_table "classroom_otu_code_categories", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "otu_code_category_id"
    t.integer  "value"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "classroom_product_links", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "spree_product_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "classrooms", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "school_id"
    t.integer  "legacy_classroom_id"
    t.integer  "processed"
    t.string   "sti_uuid"
    t.integer  "sti_id"
    t.string   "district_guid"
  end

  add_index "classrooms", ["district_guid", "sti_id"], :name => "index_classrooms_on_district_guid_and_sti_id"

  create_table "code_entry_failures", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_reports", :force => true do |t|
    t.integer  "person_id"
    t.string   "state"
    t.text     "report_data"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "render_class"
  end

  create_table "districts", :force => true do |t|
    t.string   "guid"
    t.string   "name"
    t.boolean  "alsde_study"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "current_student_version", :limit => 8
    t.integer  "current_roster_version",  :limit => 8
    t.integer  "current_section_version", :limit => 8
    t.integer  "current_staff_version",   :limit => 8
  end

  create_table "faq_questions", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.string   "person_type"
    t.integer  "place"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "features", :force => true do |t|
    t.string   "description"
    t.boolean  "shown"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "filters", :force => true do |t|
    t.integer  "minimum_grade"
    t.integer  "maximum_grade"
    t.string   "nickname"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "food_fight_matches", :force => true do |t|
    t.boolean  "active"
    t.integer  "players_turn"
    t.integer  "initiated_by"
    t.boolean  "food_thrown",         :default => false
    t.integer  "food_person_link_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "food_fight_players", :force => true do |t|
    t.integer  "food_fight_match_id"
    t.integer  "person_id"
    t.integer  "score",               :default => 0
    t.integer  "questions_answered",  :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "food_fight_players", ["food_fight_match_id"], :name => "index_food_fight_players_on_food_fight_match_id"

  create_table "food_person_links", :force => true do |t|
    t.integer  "person_id"
    t.integer  "thrown_by_id"
    t.integer  "food_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "food_school_links", :force => true do |t|
    t.integer  "food_id"
    t.integer  "school_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "foods", :force => true do |t|
    t.string   "name"
    t.string   "image_uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "games_answers", :force => true do |t|
    t.string "game_type"
    t.string "body"
  end

  create_table "games_food_fight_items", :force => true do |t|
    t.string  "name"
    t.string  "image_uid"
    t.string  "image_name"
    t.string  "splat_uid"
    t.string  "splat_name"
    t.integer "unlock_count"
  end

  create_table "games_food_fight_rounds", :force => true do |t|
    t.string   "abbr"
    t.string   "description"
    t.integer  "filter_id"
    t.integer  "question_group_id"
    t.datetime "start_date"
    t.datetime "end_date"
  end

  create_table "games_food_fight_throws", :force => true do |t|
    t.integer "round_id"
    t.integer "user_id"
    t.integer "user_answer_id"
    t.integer "food_item_id"
    t.string  "target_type"
    t.integer "target_id"
  end

  create_table "games_food_fight_user_statistics", :force => true do |t|
    t.integer "user_id"
    t.integer "round_id"
    t.integer "answered"
    t.integer "throws"
    t.integer "correct"
  end

  create_table "games_person_answers", :force => true do |t|
    t.integer  "person_id"
    t.integer  "question_id"
    t.integer  "question_answer_id"
    t.integer  "elapsed_time"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "school_id"
  end

  create_table "games_question_answers", :force => true do |t|
    t.integer "question_id"
    t.integer "answer_id"
    t.boolean "correct"
    t.string  "status"
  end

  create_table "games_question_categories", :force => true do |t|
    t.string "subject"
    t.string "category"
    t.string "status"
  end

  create_table "games_question_groupings", :force => true do |t|
    t.string  "abbr"
    t.string  "description"
    t.integer "teacher_id"
    t.integer "filter_id"
    t.string  "status"
    t.string  "game_type"
  end

  create_table "games_questions", :force => true do |t|
    t.string  "type"
    t.integer "category_id"
    t.integer "number_of_answers"
    t.integer "grade"
    t.string  "body"
    t.integer "approval_count"
    t.integer "teacher_id"
    t.integer "created_by"
    t.integer "updated_by"
    t.string  "status"
    t.string  "game_type"
  end

  create_table "interactions", :force => true do |t|
    t.integer  "person_id"
    t.string   "page"
    t.inet     "ip_address"
    t.date     "date"
    t.integer  "elapsed_milliseconds"
    t.integer  "memory_usage_kb"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "school_id"
  end

  add_index "interactions", ["created_at"], :name => "index_interactions_on_created_at"
  add_index "interactions", ["person_id"], :name => "index_interactions_on_person_id"

  create_table "jobs", :force => true do |t|
    t.string   "type",       :default => "started"
    t.string   "status"
    t.text     "details"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "local_reward_categories", :force => true do |t|
    t.string   "name"
    t.string   "image_uid"
    t.integer  "filter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locker_sticker_links", :force => true do |t|
    t.integer  "locker_id"
    t.integer  "sticker_id"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lockers", :force => true do |t|
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "message_code_links", :force => true do |t|
    t.integer  "message_id"
    t.integer  "otu_code_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "message_image_links", :force => true do |t|
    t.integer  "message_id"
    t.integer  "message_image_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "message_images", :force => true do |t|
    t.string   "image_uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "from_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "to_id"
    t.string   "subject"
    t.text     "body"
    t.string   "status"
    t.string   "category"
  end

  add_index "messages", ["category"], :name => "index_messages_on_category"
  add_index "messages", ["to_id", "category", "status"], :name => "index_messages_on_to_id_and_category_and_status"
  add_index "messages", ["to_id", "status"], :name => "index_messages_on_to_id_and_status"

  create_table "monikers", :force => true do |t|
    t.string   "state"
    t.string   "moniker"
    t.datetime "approved_at"
    t.integer  "actioned_by_id"
    t.integer  "person_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "otu_code_categories", :force => true do |t|
    t.string   "name"
    t.integer  "otu_code_type_id"
    t.integer  "person_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "school_id"
    t.integer  "value"
  end

  create_table "otu_code_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "otu_codes", :force => true do |t|
    t.string   "code"
    t.integer  "person_school_link_id"
    t.integer  "student_id"
    t.decimal  "points",                                     :null => false
    t.datetime "expires_at"
    t.datetime "redeemed_at"
    t.boolean  "ebuck",                   :default => false
    t.boolean  "active",                  :default => true
    t.integer  "otu_transaction_link_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "otu_code_category_id"
  end

  add_index "otu_codes", ["code"], :name => "index_otu_codes_on_code"
  add_index "otu_codes", ["student_id", "active"], :name => "index_otu_codes_on_student_id_and_active"

  create_table "otu_transaction_links", :force => true do |t|
    t.integer  "otu_code_id"
    t.integer  "transaction_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "dob"
    t.integer  "grade"
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.string   "type"
    t.string   "status"
    t.integer  "legacy_user_id"
    t.string   "gender"
    t.string   "salutation",             :limit => 10
    t.string   "recovery_password"
    t.boolean  "can_distribute_credits",               :default => true
    t.boolean  "can_deliver_rewards"
    t.string   "sti_uuid"
    t.boolean  "game_challengeable",                   :default => false
    t.integer  "sti_id"
    t.string   "district_guid"
    t.integer  "checking_account_id"
    t.integer  "savings_account_id"
  end

  add_index "people", ["district_guid", "sti_id"], :name => "index_people_on_district_guid_and_sti_id"
  add_index "people", ["legacy_user_id"], :name => "ppl_legacy_user_id", :unique => true
  add_index "people", ["type"], :name => "index_people_on_type"

  create_table "person_account_links", :force => true do |t|
    t.integer  "person_school_link_id"
    t.integer  "plutus_account_id"
    t.boolean  "is_main_account"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "person_account_links", ["person_school_link_id", "plutus_account_id"], :name => "index_pal_psl_account"
  add_index "person_account_links", ["plutus_account_id"], :name => "idx_pal_plutus_account_id"

  create_table "person_avatar_links", :force => true do |t|
    t.integer  "person_id"
    t.integer  "avatar_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "person_avatar_links", ["created_at"], :name => "index_user_avatar_links_on_created_at"

  create_table "person_buck_batch_links", :force => true do |t|
    t.integer  "buck_batch_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "person_school_link_id"
  end

  create_table "person_class_filter_links", :force => true do |t|
    t.integer  "filter_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "person_class", :limit => 25
  end

  add_index "person_class_filter_links", ["filter_id", "person_class"], :name => "index_person_class_filter_links_on_filter_id_and_person_class", :unique => true

  create_table "person_school_classroom_links", :force => true do |t|
    t.integer  "person_school_link_id"
    t.string   "status"
    t.boolean  "owner"
    t.integer  "classroom_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.boolean  "homeroom"
  end

  add_index "person_school_classroom_links", ["person_school_link_id", "classroom_id"], :name => "pscl_pscli_ci"
  add_index "person_school_classroom_links", ["status", "person_school_link_id", "classroom_id"], :name => "index_pscl_status_psl_classroomid"

  create_table "person_school_links", :force => true do |t|
    t.integer  "person_id"
    t.integer  "school_id"
    t.string   "status"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "ignore",                 :default => false
    t.boolean  "can_distribute_credits", :default => true
    t.boolean  "can_distribute_rewards", :default => false
  end

  add_index "person_school_links", ["person_id", "school_id"], :name => "idx_psl_person_id_school_id", :unique => true
  add_index "person_school_links", ["status", "person_id", "school_id"], :name => "psl_status_person_school"

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "plutus_accounts", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.boolean  "contra"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "cached_balance", :precision => 20, :scale => 10
  end

  add_index "plutus_accounts", ["name", "type"], :name => "index_plutus_accounts_on_name_and_type"

  create_table "plutus_amounts", :force => true do |t|
    t.string  "type"
    t.integer "account_id"
    t.integer "transaction_id"
    t.decimal "amount",         :precision => 20, :scale => 10
  end

  add_index "plutus_amounts", ["account_id", "transaction_id"], :name => "index_plutus_amounts_on_account_id_and_transaction_id"
  add_index "plutus_amounts", ["transaction_id", "account_id"], :name => "index_plutus_amounts_on_transaction_id_and_account_id"
  add_index "plutus_amounts", ["type"], :name => "index_plutus_amounts_on_type"

  create_table "plutus_transactions", :force => true do |t|
    t.string   "description"
    t.integer  "commercial_document_id"
    t.string   "commercial_document_type"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "plutus_transactions", ["commercial_document_id", "commercial_document_type"], :name => "index_transactions_on_commercial_doc"

  create_table "poll_choices", :force => true do |t|
    t.string   "choice"
    t.integer  "poll_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polls", :force => true do |t|
    t.string   "title"
    t.string   "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
    t.integer  "min_grade"
    t.integer  "max_grade"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "status"
    t.string   "type"
    t.integer  "person_id"
    t.integer  "filter_id"
    t.integer  "published_by"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "school_id"
    t.boolean  "featured",     :default => false
  end

  create_table "reward_deliveries", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "reward_id"
    t.string   "status"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "delivered_by_id"
  end

  create_table "reward_distributors", :force => true do |t|
    t.integer  "person_school_link_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "reward_exclusions", :force => true do |t|
    t.integer "school_id"
    t.integer "product_id"
  end

  create_table "reward_templates", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "min_grade"
    t.integer  "max_grade"
    t.string   "image_uid"
  end

  create_table "school_credits", :force => true do |t|
    t.integer  "school_id"
    t.string   "school_name"
    t.string   "district_guid"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
    t.integer  "total_teachers"
    t.decimal  "amount",         :precision => 10, :scale => 2, :default => 0.0, :null => false
  end

  create_table "school_filter_links", :force => true do |t|
    t.integer  "school_id"
    t.integer  "filter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "school_filter_links", ["filter_id", "school_id"], :name => "index_school_filter_links_on_filter_id_and_school_id", :unique => true

  create_table "school_product_links", :force => true do |t|
    t.integer  "school_id"
    t.integer  "spree_product_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.integer  "school_type_id"
    t.integer  "min_grade"
    t.integer  "max_grade"
    t.string   "school_phone"
    t.string   "school_mail_to"
    t.string   "logo_uid"
    t.string   "logo_name"
    t.string   "mascot_name"
    t.boolean  "school_demo"
    t.string   "status"
    t.string   "timezone"
    t.decimal  "gmt_offset"
    t.string   "distribution_model"
    t.integer  "ad_profile"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "store_subdomain"
    t.integer  "legacy_school_id"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.integer  "state_id"
    t.string   "zip"
    t.string   "sti_uuid"
    t.integer  "sti_id"
    t.string   "district_guid"
    t.boolean  "can_revoke_credits",                :default => false
    t.integer  "weekly_perfect_attendance_amount"
    t.integer  "monthly_perfect_attendance_amount"
    t.integer  "weekly_no_tardies_amount"
    t.integer  "monthly_no_tardies_amount"
    t.integer  "weekly_no_infractions_amount"
    t.integer  "monthly_no_infractions_amount"
    t.string   "credits_scope"
    t.string   "credits_type"
    t.integer  "admin_credit_percent",              :default => 5
    t.string   "printed_credit_logo_uid"
  end

  create_table "site_settings", :force => true do |t|
    t.decimal  "student_interest_rate", :precision => 8, :scale => 2
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.datetime "interest_paid_at"
  end

  create_table "spree_activators", :force => true do |t|
    t.string   "description"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "starts_at"
    t.string   "name"
    t.string   "event_name"
    t.string   "type"
    t.integer  "usage_limit"
    t.string   "match_policy", :default => "all"
    t.string   "code"
    t.boolean  "advertise",    :default => false
    t.string   "path"
  end

  create_table "spree_addresses", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "zipcode"
    t.string   "phone"
    t.string   "state_name"
    t.string   "alternative_phone"
    t.integer  "state_id"
    t.integer  "country_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "company"
  end

  add_index "spree_addresses", ["firstname"], :name => "index_addresses_on_firstname"
  add_index "spree_addresses", ["lastname"], :name => "index_addresses_on_lastname"

  create_table "spree_adjustments", :force => true do |t|
    t.integer  "source_id"
    t.decimal  "amount",          :precision => 8, :scale => 2
    t.string   "label"
    t.string   "source_type"
    t.integer  "adjustable_id"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.boolean  "mandatory"
    t.boolean  "locked"
    t.integer  "originator_id"
    t.string   "originator_type"
    t.boolean  "eligible",                                      :default => true
    t.string   "adjustable_type"
  end

  add_index "spree_adjustments", ["adjustable_id"], :name => "index_adjustments_on_order_id"

  create_table "spree_assets", :force => true do |t|
    t.integer  "viewable_id"
    t.integer  "attachment_width"
    t.integer  "attachment_height"
    t.integer  "attachment_file_size"
    t.integer  "position"
    t.string   "viewable_type",           :limit => 50
    t.string   "attachment_content_type"
    t.string   "attachment_file_name"
    t.string   "type",                    :limit => 75
    t.datetime "attachment_updated_at"
    t.text     "alt"
  end

  add_index "spree_assets", ["viewable_id"], :name => "index_assets_on_viewable_id"
  add_index "spree_assets", ["viewable_type", "type"], :name => "index_assets_on_viewable_type_and_type"

  create_table "spree_calculators", :force => true do |t|
    t.string   "type"
    t.integer  "calculable_id",   :null => false
    t.string   "calculable_type", :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "spree_configurations", :force => true do |t|
    t.string   "name"
    t.string   "type",       :limit => 50
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "spree_configurations", ["name", "type"], :name => "index_configurations_on_name_and_type"

  create_table "spree_countries", :force => true do |t|
    t.string  "iso_name"
    t.string  "iso"
    t.string  "iso3"
    t.string  "name"
    t.integer "numcode"
  end

  create_table "spree_credit_cards", :force => true do |t|
    t.string   "month"
    t.string   "year"
    t.string   "cc_type"
    t.string   "last_digits"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "start_month"
    t.string   "start_year"
    t.string   "issue_number"
    t.integer  "address_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "gateway_customer_profile_id"
    t.string   "gateway_payment_profile_id"
  end

  create_table "spree_gateways", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.string   "server",      :default => "test"
    t.boolean  "test_mode",   :default => true
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  create_table "spree_inventory_units", :force => true do |t|
    t.integer  "lock_version",            :default => 0
    t.string   "state"
    t.integer  "variant_id"
    t.integer  "order_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "shipment_id"
    t.integer  "return_authorization_id"
  end

  add_index "spree_inventory_units", ["order_id"], :name => "index_inventory_units_on_order_id"
  add_index "spree_inventory_units", ["shipment_id"], :name => "index_inventory_units_on_shipment_id"
  add_index "spree_inventory_units", ["variant_id"], :name => "index_inventory_units_on_variant_id"

  create_table "spree_line_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "variant_id"
    t.integer  "quantity",                                 :null => false
    t.decimal  "price",      :precision => 8, :scale => 2, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "spree_line_items", ["order_id"], :name => "index_line_items_on_order_id"
  add_index "spree_line_items", ["variant_id"], :name => "index_line_items_on_variant_id"

  create_table "spree_log_entries", :force => true do |t|
    t.integer  "source_id"
    t.string   "source_type"
    t.text     "details"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "spree_mail_methods", :force => true do |t|
    t.string   "environment"
    t.boolean  "active",      :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "spree_option_types", :force => true do |t|
    t.string   "name",         :limit => 100
    t.string   "presentation", :limit => 100
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "position",                    :default => 0, :null => false
  end

  create_table "spree_option_types_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "option_type_id"
  end

  create_table "spree_option_values", :force => true do |t|
    t.integer  "position"
    t.string   "name"
    t.string   "presentation"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_option_values_variants", :id => false, :force => true do |t|
    t.integer "variant_id"
    t.integer "option_value_id"
  end

  add_index "spree_option_values_variants", ["variant_id", "option_value_id"], :name => "index_option_values_variants_on_variant_id_and_option_value_id"
  add_index "spree_option_values_variants", ["variant_id"], :name => "index_option_values_variants_on_variant_id"

  create_table "spree_orders", :force => true do |t|
    t.string   "number",               :limit => 15
    t.decimal  "item_total",                         :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                              :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "state"
    t.decimal  "adjustment_total",                   :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "user_id"
    t.datetime "created_at",                                                                        :null => false
    t.datetime "updated_at",                                                                        :null => false
    t.datetime "completed_at"
    t.integer  "bill_address_id"
    t.integer  "ship_address_id"
    t.decimal  "payment_total",                      :precision => 8, :scale => 2, :default => 0.0
    t.integer  "shipping_method_id"
    t.string   "shipment_state"
    t.string   "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.integer  "store_id"
    t.integer  "school_id"
  end

  add_index "spree_orders", ["number"], :name => "index_orders_on_number"

  create_table "spree_payment_methods", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description"
    t.boolean  "active",      :default => true
    t.string   "environment", :default => "development"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.datetime "deleted_at"
    t.string   "display_on"
  end

  create_table "spree_payments", :force => true do |t|
    t.decimal  "amount",            :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "source_id"
    t.string   "source_type"
    t.integer  "payment_method_id"
    t.string   "state"
    t.string   "response_code"
    t.string   "avs_response"
  end

  add_index "spree_payments", ["order_id", "state"], :name => "index_spree_payments_on_order_id_and_state"

  create_table "spree_pending_promotions", :force => true do |t|
    t.integer "user_id"
    t.integer "promotion_id"
  end

  add_index "spree_pending_promotions", ["promotion_id"], :name => "index_spree_pending_promotions_on_promotion_id"
  add_index "spree_pending_promotions", ["user_id"], :name => "index_spree_pending_promotions_on_user_id"

  create_table "spree_preferences", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.text     "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "key"
    t.string   "value_type"
  end

  add_index "spree_preferences", ["key"], :name => "index_spree_preferences_on_key", :unique => true

  create_table "spree_product_filter_links", :force => true do |t|
    t.integer  "product_id"
    t.integer  "filter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_product_option_types", :force => true do |t|
    t.integer  "position"
    t.integer  "product_id"
    t.integer  "option_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "spree_product_person_links", :force => true do |t|
    t.integer  "product_id"
    t.integer  "person_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_product_properties", :force => true do |t|
    t.string   "value"
    t.integer  "product_id"
    t.integer  "property_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "spree_product_properties", ["product_id"], :name => "index_product_properties_on_product_id"

  create_table "spree_products", :force => true do |t|
    t.string   "name",                 :default => "",    :null => false
    t.text     "description"
    t.datetime "available_on"
    t.datetime "deleted_at"
    t.string   "permalink"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.integer  "tax_category_id"
    t.integer  "shipping_category_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "count_on_hand",        :default => 0,     :null => false
    t.string   "svg_file_name"
    t.string   "fulfillment_type"
    t.string   "purchased_by"
    t.integer  "min_grade"
    t.integer  "max_grade"
    t.boolean  "visible_to_all",       :default => false
    t.integer  "sticker_id"
  end

  add_index "spree_products", ["available_on"], :name => "index_products_on_available_on"
  add_index "spree_products", ["deleted_at"], :name => "index_products_on_deleted_at"
  add_index "spree_products", ["name"], :name => "index_products_on_name"
  add_index "spree_products", ["permalink"], :name => "index_products_on_permalink"

  create_table "spree_products_promotion_rules", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_products_promotion_rules", ["product_id"], :name => "index_products_promotion_rules_on_product_id"
  add_index "spree_products_promotion_rules", ["promotion_rule_id"], :name => "index_products_promotion_rules_on_promotion_rule_id"

  create_table "spree_products_stores", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "store_id"
  end

  add_index "spree_products_stores", ["product_id"], :name => "index_products_stores_on_product_id"
  add_index "spree_products_stores", ["store_id"], :name => "index_products_stores_on_store_id"

  create_table "spree_products_taxons", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "taxon_id"
  end

  add_index "spree_products_taxons", ["product_id"], :name => "index_products_taxons_on_product_id"
  add_index "spree_products_taxons", ["taxon_id"], :name => "index_products_taxons_on_taxon_id"

  create_table "spree_promotion_action_line_items", :force => true do |t|
    t.integer "promotion_action_id"
    t.integer "variant_id"
    t.integer "quantity",            :default => 1
  end

  create_table "spree_promotion_actions", :force => true do |t|
    t.integer "activator_id"
    t.integer "position"
    t.string  "type"
  end

  create_table "spree_promotion_rules", :force => true do |t|
    t.integer  "activator_id"
    t.integer  "user_id"
    t.integer  "product_group_id"
    t.string   "type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_promotion_rules", ["product_group_id"], :name => "index_promotion_rules_on_product_group_id"
  add_index "spree_promotion_rules", ["user_id"], :name => "index_promotion_rules_on_user_id"

  create_table "spree_promotion_rules_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "promotion_rule_id"
  end

  add_index "spree_promotion_rules_users", ["promotion_rule_id"], :name => "index_promotion_rules_users_on_promotion_rule_id"
  add_index "spree_promotion_rules_users", ["user_id"], :name => "index_promotion_rules_users_on_user_id"

  create_table "spree_properties", :force => true do |t|
    t.string   "name"
    t.string   "presentation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "spree_properties_prototypes", :id => false, :force => true do |t|
    t.integer "prototype_id"
    t.integer "property_id"
  end

  create_table "spree_prototypes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_return_authorizations", :force => true do |t|
    t.string   "number"
    t.string   "state"
    t.decimal  "amount",     :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "order_id"
    t.text     "reason"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "spree_roles", :force => true do |t|
    t.string "name"
  end

  create_table "spree_roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "spree_roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "spree_roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "spree_shipments", :force => true do |t|
    t.string   "tracking"
    t.string   "number"
    t.decimal  "cost",               :precision => 8, :scale => 2
    t.datetime "shipped_at"
    t.integer  "order_id"
    t.integer  "shipping_method_id"
    t.integer  "address_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "state"
  end

  add_index "spree_shipments", ["number"], :name => "index_shipments_on_number"
  add_index "spree_shipments", ["order_id", "state"], :name => "index_spree_shipments_on_order_id_and_state"

  create_table "spree_shipping_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "spree_shipping_methods", :force => true do |t|
    t.string   "name"
    t.integer  "zone_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "display_on"
    t.integer  "shipping_category_id"
    t.boolean  "match_none"
    t.boolean  "match_all"
    t.boolean  "match_one"
    t.datetime "deleted_at"
  end

  create_table "spree_state_changes", :force => true do |t|
    t.string   "name"
    t.string   "previous_state"
    t.integer  "stateful_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "stateful_type"
    t.string   "next_state"
  end

  create_table "spree_states", :force => true do |t|
    t.string  "name"
    t.string  "abbr"
    t.integer "country_id"
  end

  create_table "spree_stores", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "domains"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "default",    :default => false
    t.string   "email"
  end

  create_table "spree_tax_categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "is_default",  :default => false
    t.datetime "deleted_at"
  end

  create_table "spree_tax_rates", :force => true do |t|
    t.decimal  "amount",            :precision => 8, :scale => 5
    t.integer  "zone_id"
    t.integer  "tax_category_id"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.boolean  "included_in_price",                               :default => false
  end

  create_table "spree_taxonomies", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "store_id"
  end

  add_index "spree_taxonomies", ["store_id"], :name => "index_spree_taxonomies_on_store_id"

  create_table "spree_taxons", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "position",          :default => 0
    t.string   "name",                             :null => false
    t.string   "permalink"
    t.integer  "taxonomy_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.text     "description"
  end

  add_index "spree_taxons", ["parent_id"], :name => "index_taxons_on_parent_id"
  add_index "spree_taxons", ["permalink"], :name => "index_taxons_on_permalink"
  add_index "spree_taxons", ["taxonomy_id"], :name => "index_taxons_on_taxonomy_id"

  create_table "spree_tokenized_permissions", :force => true do |t|
    t.integer  "permissable_id"
    t.string   "permissable_type"
    t.string   "token"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "spree_tokenized_permissions", ["permissable_id", "permissable_type"], :name => "index_tokenized_name_and_type"

  create_table "spree_trackers", :force => true do |t|
    t.string   "environment"
    t.string   "analytics_id"
    t.boolean  "active",       :default => true
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "store_id"
  end

  create_table "spree_users", :force => true do |t|
    t.string   "encrypted_password"
    t.string   "password_salt"
    t.string   "email"
    t.string   "remember_token"
    t.string   "persistence_token"
    t.string   "reset_password_token"
    t.string   "perishable_token"
    t.integer  "sign_in_count",                        :default => 0, :null => false
    t.integer  "failed_attempts",                      :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "login"
    t.integer  "ship_address_id"
    t.integer  "bill_address_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "authentication_token"
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string   "api_key",                :limit => 48
    t.integer  "person_id"
    t.string   "username"
    t.boolean  "api_user"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "spree_users", ["confirmation_token"], :name => "index_spree_users_on_confirmation_token", :unique => true
  add_index "spree_users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "spree_users", ["person_id"], :name => "su_person_id", :unique => true
  add_index "spree_users", ["username"], :name => "su_username"

  create_table "spree_variants", :force => true do |t|
    t.string   "sku",                                         :default => "",    :null => false
    t.decimal  "price",         :precision => 8, :scale => 2,                    :null => false
    t.decimal  "weight",        :precision => 8, :scale => 2
    t.decimal  "height",        :precision => 8, :scale => 2
    t.decimal  "width",         :precision => 8, :scale => 2
    t.decimal  "depth",         :precision => 8, :scale => 2
    t.datetime "deleted_at"
    t.boolean  "is_master",                                   :default => false
    t.integer  "product_id"
    t.integer  "count_on_hand",                               :default => 0,     :null => false
    t.decimal  "cost_price",    :precision => 8, :scale => 2
    t.integer  "position"
  end

  add_index "spree_variants", ["product_id"], :name => "index_variants_on_product_id"

  create_table "spree_zone_members", :force => true do |t|
    t.integer  "zoneable_id"
    t.string   "zoneable_type"
    t.integer  "zone_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "spree_zones", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "default_tax",        :default => false
    t.integer  "zone_members_count", :default => 0
  end

  create_table "state_filter_links", :force => true do |t|
    t.integer  "state_id"
    t.integer  "filter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "state_filter_links", ["filter_id", "state_id"], :name => "index_state_filter_links_on_filter_id_and_state_id", :unique => true

  create_table "state_product_links", :force => true do |t|
    t.integer  "state_id"
    t.integer  "spree_product_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sti_link_tokens", :force => true do |t|
    t.string   "district_guid"
    t.string   "api_url"
    t.string   "link_key"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "username"
    t.string   "password"
    t.string   "status",        :default => "active"
  end

  create_table "sticker_purchases", :force => true do |t|
    t.integer  "sticker_id"
    t.integer  "person_id"
    t.datetime "expires_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stickers", :force => true do |t|
    t.string   "image_uid"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "purchasable", :default => false
    t.integer  "min_grade"
    t.integer  "max_grade"
    t.integer  "school_id"
  end

  create_table "sync_attempts", :force => true do |t|
    t.string   "district_guid"
    t.string   "status"
    t.string   "sync_type"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.text     "error"
    t.text     "backtrace"
    t.text     "students_response"
    t.text     "rosters_response"
    t.text     "schools_response"
    t.text     "sections_response"
    t.text     "staff_response"
    t.integer  "student_version",   :limit => 8
    t.integer  "section_version",   :limit => 8
    t.integer  "staff_version",     :limit => 8
    t.integer  "roster_version",    :limit => 8
  end

  create_table "teacher_credits", :force => true do |t|
    t.integer  "school_id"
    t.integer  "teacher_id"
    t.string   "teacher_name"
    t.string   "district_guid"
    t.decimal  "amount",        :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.string   "credit_source"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
    t.text     "reason"
  end

  create_table "tour_events", :force => true do |t|
    t.integer  "person_id"
    t.string   "page"
    t.string   "event_name"
    t.string   "tour_name"
    t.integer  "tour_step"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transaction_orders", :force => true do |t|
    t.integer "transaction_id"
    t.integer "order_id"
  end

  create_table "uploaded_users", :force => true do |t|
    t.string   "batch_name"
    t.text     "original_data"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.integer  "grade"
    t.string   "password"
    t.string   "type"
    t.text     "message"
    t.integer  "school_id"
    t.integer  "created_by_id"
    t.integer  "approved_by_id"
    t.integer  "person_id"
    t.string   "state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "gender"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.integer  "school_id"
    t.integer  "person_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "poll_choice_id"
    t.integer  "person_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "poll_id"
  end

end
