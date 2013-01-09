# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

LevelElement.find_or_create_by_name_and_description("goal", "The target to reach.")
LevelElement.find_or_create_by_name_and_description("fixed", "A permanently fixed piece.")
LevelElement.find_or_create_by_name_and_description("falling", "A piece that falls to the bottom.")
LevelElement.find_or_create_by_name_and_description("floating", "A piece that floats to the top.")
LevelElement.find_or_create_by_name_and_description("coin", "Optional goals to collect.")
LevelElement.find_or_create_by_name_and_description("bomb", "Destructive blocks triggered by contact with specifically-colored pieces.")
LevelElement.find_or_create_by_name_and_description("paint", "Changes the color of falling or floating pieces.")
LevelElement.find_or_create_by_name_and_description("gravity-swap", "Changes falling to floating pieces and vis a versa.")
LevelElement.find_or_create_by_name_and_description("magnet", "Permanently locks falling or floating pieces.")
LevelElement.find_or_create_by_name_and_description("teleport", "Transports pieces across the board.")