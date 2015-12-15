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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151215053627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.datetime "published_start"
    t.datetime "published_end"
    t.string   "article_type"
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "avatars", force: true do |t|
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_img_file_name"
    t.string   "avatar_img_content_type"
    t.integer  "avatar_img_file_size"
    t.datetime "avatar_img_updated_at"
    t.integer  "article_id"
  end

  create_table "locations", force: true do |t|
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
  end

  create_table "locations_topics", id: false, force: true do |t|
    t.integer "topic_id"
    t.integer "location_id"
  end

  create_table "people", force: true do |t|
    t.integer "location_id"
    t.string  "pfid"
    t.string  "name"
    t.string  "date_of_birth"
    t.string  "place_of_birth"
    t.string  "description"
  end

  add_index "people", ["location_id"], name: "index_people_on_location_id", using: :btree
  add_index "people", ["pfid"], name: "index_people_on_pfid", unique: true, using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_sources", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reference_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "typestrings"
  end

  create_table "references", force: true do |t|
    t.string   "title"
    t.string   "creator"
    t.integer  "year"
    t.string   "lang"
    t.string   "snippet"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reference_type_id"
    t.integer  "reference_source_id"
    t.integer  "topic_id"
    t.boolean  "is_dead_link",        default: false
    t.datetime "checked_at"
  end

  add_index "references", ["reference_source_id"], name: "index_references_on_reference_source_id", using: :btree
  add_index "references", ["reference_type_id"], name: "index_references_on_reference_type_id", using: :btree
  add_index "references", ["topic_id"], name: "index_references_on_topic_id", using: :btree

  create_table "rejections", force: true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "reason"
    t.boolean  "unchanged",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_topics", force: true do |t|
    t.string   "search_string"
    t.integer  "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "published"
    t.datetime "published_start"
    t.datetime "published_end"
  end

  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "role"
    t.boolean  "status"
    t.string   "reset_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.json     "object"
    t.datetime "created_at"
    t.json     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
