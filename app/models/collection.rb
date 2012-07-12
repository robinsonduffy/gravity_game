class Collection < ActiveRecord::Base
  has_many :levels
  has_many :unlocks, :dependent => :delete_all
  has_many :users_unlocked, :through => :unlocks, :source => :user
  
  validates :name, :presence => true
  validates :number, :presence => true,
                     :uniqueness => true
                     
  def percent_done(user = User.find(1))
    levels_done = 0
    self.levels.each do |level|
      levels_done = levels_done + 1 if user.completed_levels.include?(level)
    end
    ((levels_done.to_f / self.levels.count.to_f) * 100).to_i
  end
  
  def playable_by_user?(user = User.find(1))
    return true if (self.coin_cost.to_i == 0 || user.unlocked_collections.include?(self))
    return false
  end
end
