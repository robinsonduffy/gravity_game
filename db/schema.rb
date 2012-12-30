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

ActiveRecord::Schema.define(:version => 20121230003901) do

  create_table "coin_costs", :force => true do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coin_costs", ["item_id", "item_type"], :name => "index_coin_costs_on_item_id_and_item_type"

  create_table "coin_transactions", :force => true do |t|
    t.integer "user_id"
    t.integer "amount"
    t.text    "transaction_type", :limit => 255
    t.text    "note"
    t.text    "created_at",       :limit => 6
    t.text    "updated_at",       :limit => 6
  end

  add_index "coin_transactions", ["user_id"], :name => "index_coin_transactions_on_user_id"

  create_table "collections", :force => true do |t|
    t.integer "number"
    t.text    "name",       :limit => 255
    t.text    "created_at", :limit => 6
    t.text    "updated_at", :limit => 6
  end

  add_index "collections", ["number"], :name => "index_collections_on_number", :unique => true

  create_table "completions", :force => true do |t|
    t.integer "user_id"
    t.integer "level_id"
    t.text    "created_at", :limit => 6
    t.text    "updated_at", :limit => 6
  end

  add_index "completions", ["level_id"], :name => "index_completions_on_level_id"
  add_index "completions", ["user_id", "level_id"], :name => "index_completions_on_user_id_and_level_id", :unique => true
  add_index "completions", ["user_id"], :name => "index_completions_on_user_id"

  create_table "extra_attributes", :force => true do |t|
    t.text    "key",           :limit => 255
    t.text    "value",         :limit => 255
    t.integer "game_piece_id"
    t.text    "created_at",    :limit => 6
    t.text    "updated_at",    :limit => 6
  end

  add_index "extra_attributes", ["game_piece_id"], :name => "index_extra_attributes_on_game_piece_id"

  create_table "extra_classes", :force => true do |t|
    t.text    "name",          :limit => 255
    t.integer "game_piece_id"
    t.text    "created_at",    :limit => 6
    t.text    "updated_at",    :limit => 6
  end

  add_index "extra_classes", ["game_piece_id"], :name => "index_extra_classes_on_game_piece_id"

  create_table "game_pieces", :force => true do |t|
    t.text    "cell",       :limit => 255
    t.text    "piece_type", :limit => 255
    t.integer "level_id"
    t.text    "created_at", :limit => 6
    t.text    "updated_at", :limit => 6
  end

  add_index "game_pieces", ["level_id"], :name => "index_game_pieces_on_level_id"

  create_table "levels", :force => true do |t|
    t.integer "number"
    t.integer "grid_size"
    t.text    "created_at",    :limit => 6
    t.text    "updated_at",    :limit => 6
    t.integer "collection_id"
  end

  add_index "levels", ["collection_id"], :name => "index_levels_on_collection_id"
  add_index "levels", ["number"], :name => "index_levels_on_number"

  create_table "meta_data", :force => true do |t|
    t.integer "item_id"
    t.text    "item_type",  :limit => 255
    t.text    "key",        :limit => 255
    t.text    "value"
    t.text    "created_at", :limit => 6
    t.text    "updated_at", :limit => 6
  end

  add_index "meta_data", ["item_id", "item_type"], :name => "index_meta_data_on_item_id_and_item_type"
  add_index "meta_data", ["key"], :name => "index_meta_data_on_key"

  create_table "unlocks", :force => true do |t|
    t.integer "user_id"
    t.integer "collection_id"
    t.text    "created_at",    :limit => 6
    t.text    "updated_at",    :limit => 6
  end

  add_index "unlocks", ["collection_id"], :name => "index_unlocks_on_collection_id"
  add_index "unlocks", ["user_id", "collection_id"], :name => "index_unlocks_on_user_id_and_collection_id", :unique => true
  add_index "unlocks", ["user_id"], :name => "index_unlocks_on_user_id"

  create_table "users", :force => true do |t|
    t.text    "fbid",       :limit => 255
    t.text    "created_at", :limit => 6
    t.text    "updated_at", :limit => 6
    t.integer "coins"
  end

  add_index "users", ["fbid"], :name => "index_users_on_fbid", :unique => true

end
