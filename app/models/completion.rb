class Completion < ActiveRecord::Base
  
  belongs_to :level
  belongs_to :user
  has_many :meta_data, :as => :item
  
  validates :level_id, :presence => true,
                       :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true,
                      :uniqueness => {:scope => :level_id}
end
