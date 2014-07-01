class Level < ActiveRecord::Base
  has_many :game_pieces, :dependent => :delete_all
  has_many :completions, :dependent => :delete_all
  has_many :users_completed, :through => :completions, :source => :user
  has_many :meta_data, :as => :item, :dependent => :delete_all
  belongs_to :collection
  belongs_to :user
  
  validates :number, :presence => true,
                     :numericality => {:only_integer => true},
                     :positive_number => true,
                     :uniqueness => {:scope => :collection_id}
  
  validates :grid_size, :presence => true,
                        :numericality => {:only_integer => true},
                        :inclusion => {:in => 4..8}
                        
  before_save :add_level_name

  def best_rotation
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as integer) ASC").first.meta_data.find_by_key("rotations").value.to_i
    end
  end
  
  def best_locked
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as integer) ASC").first.meta_data.find_by_key("locks").value.to_i
    end
  end
  
  def best_coins
    if self.completions.length > 0
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as integer) ASC").first.meta_data.find_by_key("coins").value.to_i
    end
  end
  
  def best_score
    if self.completions.length > 0 && completions.joins(:meta_data).where("meta_data.key = 'score'").any?
      self.completions.joins(:meta_data).where("meta_data.key = 'score'").order("cast(meta_data.value as integer) ASC").first.meta_data.find_by_key("score").value.to_i
    end
  end
  
  def possible_coins
    self.game_pieces.joins(:meta_data).where("meta_data.key = '_coin_value'").select("SUM(cast(meta_data.value as integer)) as total_coins_possible").first.total_coins_possible.to_i
  end
  
  def total_lockable
    self.game_pieces.joins(:meta_data).where("meta_data.key = 'class' AND meta_data.value = 'lockable'").count
  end
  
  def top_scorers
    unless self.best_score.nil?
      self.users_completed.joins(:completions => :meta_data).where("meta_data.key = 'score' AND meta_data.value = ?", self.completions.joins(:meta_data).select("meta_data.value").where("meta_data.key = 'score'").order("cast(meta_data.value as integer)").limit(1).first.value)
    else
      []
    end
  end

  private
    def add_level_name
      if self.collection_id === 0 && self.name.to_s.strip.empty?
        words = word_list.sample(2)
        self.name = "#{words[0].capitalize} #{words[1].capitalize}"
      end
    end
  
end
