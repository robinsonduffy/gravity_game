class CoinCost < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  validates :value, :presence => true,
                        :numericality => {:only_integer => true},
                        :positive_number => true,
                        :uniqueness => {:scope => [:item_type, :item_id]}
end
