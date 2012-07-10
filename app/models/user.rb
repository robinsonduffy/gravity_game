class User < ActiveRecord::Base
  attr_accessible :fbid
  
  has_many :completions
  has_many :completed_levels, :through => :completions, :source => :level
  
  validates :fbid, :presence => true,
                   :uniqueness => true
                   
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
