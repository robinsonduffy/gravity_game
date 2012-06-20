class Collection < ActiveRecord::Base
  has_many :levels
  
  validates :name, :presence => true
  validates :number, :presence => true,
                     :uniqueness => true
end
