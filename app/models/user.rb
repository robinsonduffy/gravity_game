class User < ActiveRecord::Base
  
  has_many :completions, :dependent => :destroy
  has_many :completed_levels, :through => :completions, :source => :level
  
  validates :fbid, :presence => true,
                   :uniqueness => true
  
end
