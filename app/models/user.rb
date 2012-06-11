class User < ActiveRecord::Base
  
  has_many :completions
  has_many :completed_levels, :through => :completions, :source => :level
  
  validates :fbid, :presence => true,
                   :uniqueness => true
  
end
