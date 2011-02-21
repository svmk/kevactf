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

ActiveRecord::Schema.define(:version => 20110118081650) do

  create_table "comments", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "news_item_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hints", :force => true do |t|
    t.text     "content"
    t.boolean  "show"
    t.integer  "quest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keva_configs", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_items", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quest_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quests", :force => true do |t|
    t.text     "title"
    t.text     "description"
    t.text     "syscmd"
    t.integer  "price"
    t.integer  "quest_type_id"
    t.boolean  "show"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quests_users", :id => false, :force => true do |t|
    t.integer  "quest_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "nickname"
    t.string   "realname"
    t.text     "university"
    t.text     "email"
    t.text     "password"
    t.boolean  "enabled"
    t.boolean  "admin"
    t.integer  "price"
    t.text     "md5hash"
    t.time     "last_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
