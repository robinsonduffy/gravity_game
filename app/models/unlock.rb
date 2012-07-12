class Unlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :collection
  
  validates :collection_id, :presence => true,
                            :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true,
                      :uniqueness => {:scope => :collection_id}
end
