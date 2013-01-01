class LevelElement < ActiveRecord::Base
  has_one :coin_cost, :as => :item, :dependent => :destroy
  has_many :unlocks, :as => :item, :dependent => :delete_all
  has_many :users_unlocked, :through => :unlocks, :as => :item, :source => :user

  validates :name, :presence => true,
                   :uniqueness => true
  validates :description, :presence => true
end
