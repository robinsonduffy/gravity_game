class User < ActiveRecord::Base
  attr_accessible :fbid
  
  has_many :completions
  has_many :completed_levels, :through => :completions, :source => :level
  has_many :unlocks, :dependent => :destroy
  has_many :unlocked_collections, :through => :unlocks, :source => :collection
  has_many :coin_transactions, :dependent => :destroy
  
  validates :fbid, :presence => true,
                   :uniqueness => true
  

  def best_rotation(level)
    self.completions.joins(:meta_data).where("meta_data.key = 'rotations' AND completions.level_id = ?", level.id).first.meta_data.find_by_key("rotations").value.to_i
  end

  def best_locked(level)
    self.completions.joins(:meta_data).where("meta_data.key = 'locks' AND completions.level_id = ?", level.id).first.meta_data.find_by_key("locks").value.to_i
  end

  def best_coins(level)
    self.completions.joins(:meta_data).where("meta_data.key = 'coins' AND completions.level_id = ?", level.id).first.meta_data.find_by_key("coins").value.to_i
  end              
  
  def best_score(level)
    self.completions.joins(:meta_data).where("meta_data.key = 'score' AND completions.level_id = ?", level.id).first.meta_data.find_by_key("score").value.to_i
  end
  
  def add_coins(amount)
    self.update_attribute(:coins, self.coins + amount)
  end
  
  def remove_coins(amount)
    amount = self.coins if amount > self.coins
    self.update_attribute(:coins, self.coins - amount)
  end
  
end
