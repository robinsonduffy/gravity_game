class Unlock < ActiveRecord::Base
  belongs_to :user
  belongs_to :item, :polymorphic => true
  
  validates :item_id, :presence => true,
                      :uniqueness => {:scope => [:user_id, :item_type]}
  validates :item_type, :presence => true
  validates :user_id, :presence => true,
                      :uniqueness => {:scope => [:item_id, :item_type]}
end
