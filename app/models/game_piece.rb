class GamePiece < ActiveRecord::Base
  belongs_to :level
  has_many :meta_data, :as => :item, :dependent => :delete_all
  
  validates :cell, :presence => true
  validates :piece_type, :presence => true,
                         :inclusion => {:in => game_piece_types}
  
  def class_hash
    class_array = Array.new
    class_array.push self.piece_type
    self.meta_data.each do |extra_class|
      class_array.push extra_class.value if extra_class.key == 'class' || extra_class.key == '_color'
    end
    return {:class => class_array}
  end
  
  def attributes_hash
    attribute_hash = Hash.new
    attribute_hash['_cell'] = self.cell
    self.meta_data.each do |extra_attribute|
      attribute_hash[extra_attribute.key] = extra_attribute.value if extra_attribute.key != 'class'
    end
    return attribute_hash
  end
end
