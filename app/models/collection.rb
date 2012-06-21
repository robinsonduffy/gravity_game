class Collection < ActiveRecord::Base
  has_many :levels
  
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
end
