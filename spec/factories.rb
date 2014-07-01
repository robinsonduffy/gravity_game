Factory.define :collection do |collection|
  collection.number 1
  collection.name "Collection One"
end

Factory.define :level do |level|
  level.number 1
  level.grid_size 4
  level.association :collection
end

Factory.define :game_piece do |game_piece|
  game_piece.cell "1,1"
  game_piece.piece_type "goal"
  game_piece.association :level
end

Factory.define :extra_attribute do |extra_attribute|
  extra_attribute.key "_color"
  extra_attribute.value "red"
  extra_attribute.association :game_piece
end

Factory.define :extra_class do |extra_class|
  extra_class.name "lockable"
  extra_class.association :game_piece
end

Factory.define :user do |user|
  
end