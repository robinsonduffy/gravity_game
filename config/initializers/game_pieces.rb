def game_piece_types
  ['game-piece','goal','station']
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
      }
    when "falling"
      {
        :piece_type => 'game-piece',
        :lockable => true,
        :colors => game_piece_default_colors
      }
    when "floating"
      {
        :piece_type => 'game-piece',
        :lockable => true,
        :colors => game_piece_default_colors
      }
    when "goal"
      {
        :piece_type => 'goal',
        :lockable => false,
        :colors => game_piece_default_colors
      }
    when "coin"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => {
          'green' => 1,
          'blue' => 5,
          'yellow' => 10,
          'red' => 25
        }
      }
    when "bomb"
      {
        :piece_type => 'game-piece',
        :lockable => false,
        :colors => game_piece_default_colors
      }
    when "paint"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => game_piece_default_colors
      }
    when "gravity-swap"
      {
        :piece_type => 'station',
        :lockable => false,
      }
    when "magnet"
      {
        :piece_type => 'station',
        :lockable => false,
      }
    when "teleport"
      {
        :piece_type => 'station',
        :lockable => false,
        :colors => game_piece_default_colors
      }
    else
      nil
  end
end