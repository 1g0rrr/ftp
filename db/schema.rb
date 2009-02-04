# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081203144623) do

  create_table "comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "entity_id"
    t.integer  "karma"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dev_blog_comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "dev_blog_post_id"
    t.integer  "karma"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dev_blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.integer  "is_hide"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entities", :force => true do |t|
    t.string   "title"
    t.string   "photo"
    t.text     "description"
    t.integer  "is_submit"
    t.integer  "user_id"
    t.string   "category"
    t.integer  "sub_category"
    t.integer  "karma"
    t.string   "file_name"
    t.string   "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_ext"
    t.string   "photo_width"
    t.string   "photo_height"
    t.string   "photo_filename"
    t.integer  "is_transfer"
  end

  create_table "users", :force => true do |t|
    t.string   "uname"
    t.string   "real_name"
    t.string   "second_name"
    t.string   "sex"
    t.text     "about"
    t.date     "birthday"
    t.string   "icq"
    t.string   "email"
    t.string   "photo"
    t.string   "perms"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password"
  end

end
