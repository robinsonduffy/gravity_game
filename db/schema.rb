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

ActiveRecord::Schema.define(:version => 20120712053155) do

  create_table "collections", :force => true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coin_cost",  :default => 0
  end

  add_index "collections", ["number"], :name => "index_collections_on_number", :unique => true

  create_table "completions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "completions", ["level_id"], :name => "index_completions_on_level_id"
  add_index "completions", ["user_id", "level_id"], :name => "index_completions_on_user_id_and_level_id", :unique => true
  add_index "completions", ["user_id"], :name => "index_completions_on_user_id"

  create_table "game_pieces", :force => true do |t|
    t.string   "cell"
    t.string   "piece_type"
    t.integer  "level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_pieces", ["level_id"], :name => "index_game_pieces_on_level_id"

  create_table "levels", :force => true do |t|
    t.integer  "number"
    t.integer  "grid_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id"
  end

  add_index "levels", ["collection_id"], :name => "index_levels_on_collection_id"
  add_index "levels", ["number"], :name => "index_levels_on_number"

  create_table "meta_data", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meta_data", ["item_id", "item_type"], :name => "index_meta_data_on_item_id_and_item_type"
  add_index "meta_data", ["key"], :name => "index_meta_data_on_key"

  create_table "unlocks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "collection_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "unlocks", ["collection_id"], :name => "index_unlocks_on_collection_id"
  add_index "unlocks", ["user_id", "collection_id"], :name => "index_unlocks_on_user_id_and_collection_id", :unique => true
  add_index "unlocks", ["user_id"], :name => "index_unlocks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "fbid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "coins",      :default => 0
  end

  add_index "users", ["fbid"], :name => "index_users_on_fbid", :unique => true

end
