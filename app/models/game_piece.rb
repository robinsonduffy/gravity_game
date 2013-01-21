class GamePiece < ActiveRecord::Base
  belongs_to :level
  has_many :meta_data, :as => :item, :dependent => :delete_all, :autosave => true
  
  validates :cell, :presence => true
  validates :piece_type, :presence => true,
                         :inclusion => {:in => game_piece_types}
  validates :piece, :presence => true,
                    :inclusion => {:in => game_piece_pieces}
  
  def class_hash
    class_array = Array.new
    class_array.push self.piece_type
    class_array.push self.piece unless class_array.include? self.piece
    self.meta_data.each do |extra_class|
      class_array.push extra_class.value if extra_class.key == 'class' || extra_class.key == '_color'
    end
    return {:class => class_array}
  end
  
  def attributes_hash
    attribute_hash = Hash.new
    attribute_hash['_cell'] = self.cell
    attribute_hash['_game_piece_id'] = self.id
    attribute_hash['_piece_type'] = self.piece_type
    attribute_hash['_piece'] = self.piece
    self.meta_data.each do |extra_attribute|
      attribute_hash[extra_attribute.key] = extra_attribute.value if extra_attribute.key != 'class'
    end
    return attribute_hash
  end
end
