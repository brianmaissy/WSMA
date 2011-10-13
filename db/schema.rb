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

ActiveRecord::Schema.define(:version => 20111012143917) do

  create_table "encrypted_connections", :force => true do |t|
    t.string   "public_key"
    t.string   "private_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "houses", :force => true do |t|
    t.string   "name"
    t.date     "semester_start_date"
    t.integer  "permanent_chores_start_week"
    t.decimal  "hours_per_week"
    t.decimal  "sign_off_by_hours_after"
    t.integer  "using_online_sign_off"
    t.integer  "sign_off_verification_mode"
    t.decimal  "blow_off_penalty_factor"
    t.string   "new_week_job_id"
    t.string   "wsm_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "jom_social_id"
    t.integer  "access_level"
    t.string   "name"
    t.string   "phone_number"
    t.string   "room_number"
    t.decimal  "hours_per_week"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
