class User < ActiveRecord::Base
  
  validates :fbid, :presence => true,
                   :uniqueness => true
  
end
