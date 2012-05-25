class ExtraAttribute < ActiveRecord::Base
  belongs_to :game_piece
  
  validates :key, :presence => true,
                  :uniqueness => {:scope => :game_piece_id}
  validates :value, :presence => true
end
