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
      self.completions.joins(:meta_data).where("meta_data.key = 'rotations'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("rotations").value.to_i
    end
  end
  
  def total_lockable
    self.game_pieces.joins(:meta_data).where("meta_data.key = 'class' AND meta_data.value = 'lockable'").count
  end
  
  def best_locked
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'locks'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("locks").value.to_i
    end
  end
  
  def best_coins
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'coins'").order("cast(meta_data.value as unsigned) ASC").first.meta_data.find_by_key("coins").value.to_i
    end
  end
  
end
