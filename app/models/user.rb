class User < ActiveRecord::Base
  
  has_many :completions
  has_many :completed_levels, :through => :completions, :source => :level
  
  validates :fbid, :presence => true,
                   :uniqueness => true
                   
  def best_rotation(level)
    self.completions.joins(:meta_data).where("meta_data.key = 'rotations' AND completions.level_id = ?", level.id).first.meta_data.find_by_key("rotations").value.to_i
  end
end
