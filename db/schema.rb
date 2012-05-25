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

ActiveRecord::Schema.define(:version => 20120525040731) do

  create_table "extra_attributes", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "game_piece_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extra_attributes", ["game_piece_id"], :name => "index_extra_attributes_on_game_piece_id"

  create_table "extra_classes", :force => true do |t|
    t.string   "class_name"
    t.integer  "game_piece_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "extra_classes", ["game_piece_id"], :name => "index_extra_classes_on_game_piece_id"

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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levels", ["number"], :name => "index_levels_on_number"

end
