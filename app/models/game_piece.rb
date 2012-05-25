class GamePiece < ActiveRecord::Base
  belongs_to :level
  has_many :extra_attributes
  has_many :extra_classes
end
