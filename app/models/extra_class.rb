class ExtraClass < ActiveRecord::Base
  belongs_to :game_piece
  
  validates :name, :presence => true,
                   :uniqueness => {:scope => :game_piece_id}
end
