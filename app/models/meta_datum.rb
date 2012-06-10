class MetaDatum < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  
  validates :key, :presence => true
  validates :value, :presence => true
end
