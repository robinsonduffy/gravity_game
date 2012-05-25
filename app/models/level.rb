class Level < ActiveRecord::Base
  has_many :game_pieces
  
  validates :number, :presence => true,
                     :numericality => {:only_integer => true},
                     :positive_number => true
  
end
