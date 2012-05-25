Factory.define :level do |level|
  level.number 1
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