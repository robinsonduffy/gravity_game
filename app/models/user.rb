class User < ActiveRecord::Base
  authenticates_with_sorcery!
  attr_accessible :username, :email, :password, :password_confirmation
  
  has_many :completions
  has_many :completed_levels, :through => :completions, :source => :level
  has_many :unlocks, :dependent => :destroy
  has_many :unlocked_collections, :through => :unlocks, :source => :item, :source_type => "Collection"
  has_many :unlocked_level_elements, :through => :unlocks, :source => :item, :source_type => "LevelElement"
  has_many :coin_transactions, :dependent => :destroy
  has_many :levels
  
  validates :password, :presence => true, 
                       :confirmation => true, 
                       :length => {:within => 6..40}
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/
  validates :email, :presence => true, 
                    :uniqueness => {:case_sensitve => false},
                    :format => { :with => email_regex }
  
  validates :username,  :presence => true,
                        :uniqueness => {:case_sensitive => false},
                        :length => {:within => 6..40}
                    
  

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

  def can_edit_level?(level)
    return (self.admin? || (level.collection_id === 0 && self == level.user && !level.published?))
  end
end
