class Completion < ActiveRecord::Base
  
  belongs_to :level
  belongs_to :user
  has_many :meta_data, :as => :item
end
