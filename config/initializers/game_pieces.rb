def game_piece_types
  ['game-piece','goal','station']
end

def game_piece_pieces
  ['fixed','falling','floating','goal','coin','bomb','paint','gravity-swap','magnet','teleport','gate']
end

def game_piece_default_colors
  ['blue','green','orange','purple','red','yellow']
end

def game_piece_info(piece_name)
  case piece_name
    when "fixed"
      {
        :piece_type => 'game-piece',
        :lockable => false,
        :configurable => false,
      }
    when "falling"
      {
        :piece_type => 'game-piece',
        :lockable => true,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    when "floating"
      {
        :piece_type => 'game-piece',
        :lockable => true,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    when "goal"
      {
        :piece_type => 'goal',
        :lockable => false,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    when "coin"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => [
          'green',
          'blue',
          'yellow',
          'red'
        ],
        :color_values => {
          'green' => 1,
          'blue' => 5,
          'yellow' => 10,
          'red' => 25
        },
        :configurable => true,
      }
    when "bomb"
      {
        :piece_type => 'game-piece',
        :lockable => false,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    when "paint"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    when "gravity-swap"
      {
        :piece_type => 'station',
        :lockable => false,
        :configurable => false,
      }
    when "magnet"
      {
        :piece_type => 'station',
        :lockable => false,
        :configurable => false,
      }
    when "teleport"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => game_piece_default_colors,
        :configurable => false,
      }
    when "gate"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => game_piece_default_colors,
        :configurable => true,
      }
    else
      nil
  end
end

def game_piece_valid_classes
  ['locked','lockable','magnetized']
end

def game_piece_valid_attributes
  ['color','teleport_exit_cell','coin_value']
end