class PositiveNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "must be greater than zero" if !value.nil? && value <= 0
  end
end

class Level < ActiveRecord::Base
  has_many :game_pieces 
  has_many :completions, :dependent => :delete_all
  has_many :users_completed, :through => :completions, :source => :user
  has_many :meta_data, :as => :item, :dependent => :delete_all
  
  validates :number, :presence => true,
                     :numericality => {:only_integer => true},
                     :positive_number => true
  
  validates :grid_size, :presence => true,
                        :numericality => {:only_integer => true},
                        :inclusion => {:in => 4..8}
                        
  def best_rotation
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("rotations").value.to_i
    end
  end
  
  def best_locked
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("locks").value.to_i
    end
  end
  
  def best_coins
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("coins").value.to_i
    end
  end
  
  def best_score
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("score").value.to_i
    end
  end
  
  def possible_coins
    self.game_pieces.joins(:meta_data).where("meta_data.key = '_coin_value'").select("SUM(cast(meta_data.value as unsigned)) as total_coins_possible").first.total_coins_possible.to_i
  end
  
  def total_lockable
    self.game_pieces.joins(:meta_data).where("meta_data.key = 'class' AND meta_data.value = 'lockable'").count
  end
  
end
